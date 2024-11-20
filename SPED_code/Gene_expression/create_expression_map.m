function create_expression_map(INPUT_DIR, PROBE_NUMBER, METHOD, OUTPUT_DIR_NAME)
% function creates expression map for given probe
% -----<<<<<INPUT ARGUMENTS>>>>>-----
% INPUT_DIR         <----path to directory where AllenBrain data is stored
% PROBE_NUMBER      <----probe number for gene of interest, can be found in file
%                        Probes.csv
% METHOD            <----3 methods available
%   nn              <-------nearest neighbour 
%   linear          <-------linear (default)
%   sphere          <-------nearest neighbour bounded by sphere
% OUTPUT_DIR_NAME   <----path to output dir (optional), if not provided
%                        saves files to INPUT_DIR
%
% -----<<<<<OUTPUT ARGUMENTS>>>>>-----
%   every method creates nii.gz file with interpolated data
%
% INPUT FILES
% script relies on AllenBrain Atlas data, can be downloaded from
% human.brain-map.org/static/download
% 
% files neccessary to run the script (to be found in PATH directory)
% 'T1.nii.gz';                     <----brain image
% 'SampleAnnot.csv';               <----coordinates file
% 'MicroarrayExpression.csv';      <----expression file
% 'mask.nii.gz';                   <----mask file (optional)
%
% Genetic networks of the oxytocin system in the human brain: A gene expression and large-scale fMRI meta-analysis study
% Daniel S. Quintana, Jaroslav Rokicki, Dennis van der Meer, Dag Alnæs, Tobias Kaufmann, Aldo Córdova Palomera, Ingrid Dieset, Ole A. Andreassen, and Lars T. Westlye
%
% Correspondence to Daniel S. Quintana, NORMENT KG Jebsen Centre for Psychosis Research, University of Oslo
% email: daniel.quintana@medisin.uio.no
%
% Copyright 2017 Quintana et al.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

if nargin<3
    METHOD='linear';
end
if nargin<4
   OUTPUT_DIR_NAME=INPUT_DIR;
end


validMethods={'sphere','linear','NN'};
METHOD=validatestring(METHOD,validMethods);

if (exist('load_untouch_nii'))
else
    error('No NIFTI lib, download it from https://se.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image and add to MATLAB path')
end

INPUT_FILE='T1.nii';                         %<----image file
COORDINATES_FILE='SampleAnnot.csv';             %<----coordinates file
EXPRESSION_FILE='MicroarrayExpression.csv';     %<----expression file
MASK_FILE='mask.nii.gz';    

if(exist(OUTPUT_DIR_NAME, 'dir')==0)
    mkdir(OUTPUT_DIR_NAME);
end

disp(['READING T1 FILE: ', INPUT_DIR, INPUT_FILE])
if(exist([INPUT_DIR,'/', INPUT_FILE], 'file'))
	PET_NII=load_untouch_nii([INPUT_DIR, '/', INPUT_FILE]);
else
	error('Please copy T1.nii.gz to data directory (downloadable from http://human.brain-map.org/mri_viewers/data)')
end

if (exist([INPUT_DIR, '/', MASK_FILE],'file'))
    MASK_NII=load_untouch_nii([INPUT_DIR, '/',MASK_FILE]);
    mask=MASK_NII.img;  
else
    [vals,centers]=hist(double(PET_NII.img(:)),8);
    [~, second_max_position]=max(vals(2:end));
    [~, min_position]=min(vals(2:second_max_position));
    mask=PET_NII.img;
    mask(mask<(centers(min_position+1))*0.7)=0;
    mask(mask>=(centers(min_position+1))*0.7)=1;
    PET_NII.img=mask;
    warning(['PANIC ON SHIP: mask file is not found. Generating crude mask file and suggesting to create mask with external tool (SPM, FSL, ANTs), and save to data directory as mask.nii.gz']);
    disp(['SAVING NEAREST NEIGHBOUR INTERPOLATION FILE, TO: ',[ OUTPUT_DIR_NAME, '/mask_crude.nii.gz']])
    save_untouch_nii(PET_NII, [ INPUT_DIR, '/mask_crude.nii.gz']);       
end




% reading csv files
[~, ~, ~, ~, ~, ~, ~, mri_voxel_x, mri_voxel_y, mri_voxel_z, mni_x, ~, ~] = textread([INPUT_DIR, '/', COORDINATES_FILE], '%d %d %d %q %q %q %u %d %d %d %f %f %f', 'delimiter', ',', 'headerlines',1);

disp(['READING EXPRESSION FILE: ', INPUT_DIR, EXPRESSION_FILE])
expression = textread([INPUT_DIR, '/', EXPRESSION_FILE], '%f', 'delimiter', ',');
expression=reshape(expression, size(mni_x,1)+1, []);
expression_index=find(expression(1,:)==PROBE_NUMBER);
probe_matrix=expression(2:end,expression_index(:)); % <- dropping first column, which is a probe number

% creating a coord vector
coord_matrix=[mri_voxel_x, mri_voxel_y,mri_voxel_z ];



%% interpolating values


% determining expression values on the surface of a brain
mask_dilated=imdilate(mask,ones(3,3));
BW=mask_dilated-mask;
    
[x0,y0,z0]=ndgrid(1:size(mask,1), 1:size(mask,2), 1:size(mask,3));
[unique_index]=find(mask_dilated(:)>0);

xx=x0(unique_index);
yy=y0(unique_index);
zz=z0(unique_index);

XI=[xx(:),yy(:),zz(:)];
yi=zeros(length(x0(:)),1);

PET_NII.hdr.dime.datatype=64;
PET_NII.hdr.dime.bitpix=64;

%%
yi(unique_index)=griddatan(double(coord_matrix), probe_matrix, XI,'nearest');
    
if (strcmpi(METHOD,'NN'))
    interpolated_image=reshape(yi, size(mask));
    interpolated_image=double(mask).*interpolated_image;
    PET_NII.img=interpolated_image;
    disp(['SAVING NEAREST NEIGHBOUR INTERPOLATION FILE, TO: ',[ OUTPUT_DIR_NAME, '/NN.nii.gz']])
    save_untouch_nii(PET_NII, [ OUTPUT_DIR_NAME, '/NN.nii.gz']);
end

%%

if (strcmpi(METHOD,'linear'))
    interpolated_BW=reshape(yi, size(mask)).*double(BW);
    [border_index, ~, border_value]=find(interpolated_BW(:));
    [border_x, border_y, border_z]=ind2sub(size(BW),border_index);

    coord_matrix_full=[coord_matrix; [border_x(1:2:end) border_y(1:2:end) border_z(1:2:end)]];
    probe_matrix_full=[probe_matrix; border_value(1:2:end)]; 


    long_index=sub2ind(size(BW),coord_matrix_full(:,1),coord_matrix_full(:,2),coord_matrix_full(:,3));
    u=unique(long_index);
    index_unique=histc(long_index,u);

    coord_matrix_full(index_unique>1,:)=[];
    probe_matrix_full(index_unique>1)=[];

    yi=zeros(length(x0(:)),1);
    yi(unique_index)=griddatan(double(coord_matrix_full), probe_matrix_full, XI,'linear');


    interpolated_image=reshape(yi, size(mask));
    interpolated_image=double(mask).*interpolated_image;


    interpolated_image(isnan(interpolated_image))=0;
    PET_NII.img=interpolated_image;
    disp(['SAVING LINEAR INTERPOLATION FILE, TO: ',[ OUTPUT_DIR_NAME, '/linear.nii.gz']])
    save_untouch_nii(PET_NII, [OUTPUT_DIR_NAME, '/',num2str(PROBE_NUMBER) ,'linear.nii']);
end


if (strcmpi(METHOD,'sphere'))
    yi(unique_index)=griddatan(double(coord_matrix), (1:length(probe_matrix))', XI,'nearest');
    interpolated_image=reshape(yi, size(mask));
    interpolated_image=double(mask).*interpolated_image;

    distance_map=zeros(size(interpolated_image));
    for i=1:length(probe_matrix)
        mask_small=interpolated_image;
        mask_small(mask_small~=i)=0;
        mask_small(mask_small==i)=1;
        tmp=distance_3D(interpolated_image, coord_matrix(i,:), mask_small);
        distance_map=distance_map+tmp;
        distance_map(coord_matrix(i,1),coord_matrix(i,2),coord_matrix(i,3))=0.001;
    end

    mm=8;  %radius of sphere
    
    
    distance_map=mm-distance_map;
    distance_map(distance_map>=mm)=0;
    distance_map(distance_map<0)=0;
    non_zeros_index=find(distance_map~=0);
    non_zeros=distance_map(distance_map~=0);
    
    %non linear weighting function to give more weight for points closer to actual sample
    non_zeros=log(non_zeros+mm/2)/log(mm); 
    non_zeros(non_zeros>1)=1;
    distance_map(non_zeros_index(:))=non_zeros;

    yi(unique_index)=griddatan(double(coord_matrix), probe_matrix, XI,'nearest');
    interpolated_image=reshape(yi, size(mask));
    interpolated_image=double(mask).*interpolated_image;  
    

    PET_NII.img=distance_map.*interpolated_image;
    disp(['SAVING SPHERE BOUNDED FILE, TO: ',[ OUTPUT_DIR_NAME, '/sphere.nii.gz']])
    save_untouch_nii(PET_NII, [OUTPUT_DIR_NAME, '/sphere.nii.gz']);
end
