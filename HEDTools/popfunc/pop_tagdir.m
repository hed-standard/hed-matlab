% Allows a user to tag a directory of datasets using a GUI. pop_tagdir
% first brings up a GUI to allow the user to set parameters for the tagdir
% function, and then calls tagdir to consolidate the tags from all of the
% data files in the specified directories. Depending on the arguments,
% tagdir may bring up a menu to allow the user to choose which fields
% should be tagged. The tagdir function may also bring up the CTAGGER GUI
% to allow users to edit the tags.
%
% Usage:
%
%   >>  [fMap, fPaths, com] = pop_tagdir()
%
%   >>  [fMap, fPaths, com] = pop_tagdir(UseGui, 'key1', value1 ...)
%
%   >>  [fMap, fPaths, com] = pop_tagdir('key1', value1 ...)
%
% Input:
%
%   Optional:
%
%   UseGui
%                    If true (default), use a series of menus to set
%                    function arguments.
%
%   Optional (key/value):
%
%   'BaseMap'
%                    A fieldMap object or the name of a file that contains
%                    a fieldMap object to be used to initialize tag
%                    information.
%
%   'CopyDatasets'
%                    If true, copy the datasets to the 'CopyDestination'
%                    directory and write the HED tags to them.
%
%   'CopyDestination'
%                    The full path of a directory to copy the original
%                    datasets to and write the HED tags to them.
%
%   'DoSubDirs'
%                    If true (default), the entire inDir directory tree is
%                    searched. If false, only the inDir directory is
%                    searched.
%
%   'EventFieldsToIgnore'
%                    A one-dimensional cell array of field names in the
%                    .event substructure to ignore during the tagging
%                    process. By default the following subfields of the
%                    .event structure are ignored: .latency, .epoch,
%                    .urevent, .hedtags, and .usertags. The user can
%                    over-ride these tags using this name-value parameter.
%
%   'FMapDescription'
%                    The description of the fieldMap object. The
%                    description will show up in the .etc.tags.description
%                    field of any datasets tagged by this fieldMap.
%
%   'FMapSaveFile'
%                    A string representing the file name for saving the
%                    final, consolidated fieldMap object that results from
%                    the tagging process.
%
%   'HEDExtensionsAllowed'
%                    If true (default), the HED can be extended. If
%                    false, the HED cannot be extended. The
%                    'ExtensionAnywhere argument determines where the HED
%                    can be extended if extension are allowed.
%
%   'HEDExtensionsAnywhere'
%                    If true, the HED can be extended underneath all tags.
%                    If false (default), the HED can only be extended where
%                    allowed. These are tags with the 'ExtensionAllowed'
%                    attribute or leaf tags (tags that do not have
%                    children).
%
%   'HedXML'
%                    Full path to a HED XML file. The default is the
%                    HED.xml file in the hed directory.
%
%   'InDir'
%                    A directory that contains similar EEG .set files.
%
%   'OverwriteDatasets'
%                    If true, write the the HED tags to the original
%                    datasets.
%
%   'OverwriteUserHed'
%                    If true, overwrite/create the 'HED_USER.xml' file with
%                    the HED from the fieldMap object. The
%                    'HED_USER.xml' file is made specifically for modifying
%                    the original 'HED.xml' file. This file will be written
%                    under the 'hed' directory.
%
%   'PreserveTagPrefixes'
%                    If false (default), tags for the same field value that
%                    share prefixes are combined and only the most specific
%                    is retained (e.g., /a/b/c and /a/b become just
%                    /a/b/c). If true, then all unique tags are retained.
%
%   'PrimaryEventField'
%                    The name of the primary field. Only one field can be
%                    the primary field. A primary field requires a label,
%                    category, and a description tag. The default is the
%                    .type field.
%
%   'SelectEventFields'
%                    If true (default), the user is presented with a
%                    GUI that allow users to select which fields to tag.
%
%   'SeparateUserHedFile'
%                    The full path and file name to write the HED from the
%                    fieldMap object to. This file is meant to be
%                    stored outside of the HEDTools.
%
%   'UseCTagger'
%                    If true (default), the CTAGGER GUI is used to edit
%                    field tags.
%
%   'WriteFMapToFile'
%                    If true, write the fieldMap object to the
%                    specified 'FMapSaveFile' file.
%
%   'WriteSeparateUserHedFile'
%                    If true, write the fieldMap object to the file
%                    specified by the 'SeparateUserHedFile' argument.
%
% Output:
%
%   fMap             A fieldMap object that contains the tag map
%                    information.
%
%   fPaths           A list of full file names of the datasets to be
%                    tagged.
%
%   com              String containing call to tagdir with all
%                    parameters.
%
% Copyright (C) 2012-2016 Thomas Rognon tcrognon@gmail.com,
% Jeremy Cockfield jeremy.cockfield@gmail.com, and
% Kay Robbins kay.robbins@utsa.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA

function [fMap, fPaths, com] = pop_tagdir(varargin)
fMap = '';
fPaths = '';
com = '';

p = parseArguments(varargin{:});
% Get the input parameters
inputArgs = getkeyvalue({'BaseMap', 'HedExtensionsAllowed', ...
        'HedExtensionsAnywhere', 'HedXml', 'InDir', ...
        'PreserveTagPrefixes', 'UseCTagger', 'EventFieldsToIgnore', 'DoSubDirs'}, ...
        varargin{:});
    
% Call function with menu
if p.UseGui
    % Initial tagging (merge base map if provided)
    [fMap, fPaths] = tagdir(inDir, inputArgs{:});
    fMap.setPrimaryMap(p.PrimaryEventField); % default is 'type'
    
    % Show select field and tag window where the actual tagging happens
    [fMap, canceled, ~] = selectFieldAndTag(fMap, p);
    
    if canceled
        fprintf('Tagging was canceled\n');
        return;
    end
    fprintf('Tagging complete\n');
    
    % Save HED if modified
    if fMap.getXmlEdited()
        savehedInputArgs = getkeyvalue({'OverwriteUserHed', ...
            'SeparateUserHedFile', 'WriteSeparateUserHedFile'}, ...
            varargin{:});
        [fMap, overwriteUserHed, separateUserHedFile, ...
            writeSeparateUserHedFile] = pop_savehed(fMap, ...
            savehedInputArgs{:});
        savehedOutputArgs = {'OverwriteUserHed', overwriteUserHed, ...
            'SeparateUserHedFile', separateUserHedFile, ...
            'WriteSeparateUserHedFile', writeSeparateUserHedFile};
        inputArgs = [inputArgs savehedOutputArgs];
    end
    
    % Save field map containing tags
    savefmapInputArgs = getkeyvalue({'FMapDescription', ...
        'FMapSaveFile', 'WriteFMapToFile'}, varargin{:});
    [fMap, fMapDescription, fMapSaveFile] = ...
        pop_savefmap(fMap, savefmapInputArgs{:});
    savefmapOutputArgs = {'FMapDescription', fMapDescription, ...
        'FMapSaveFile', fMapSaveFile};
    
    % Save datasets
    saveheddatasetsInputArgs = getkeyvalue({'CopyDatasets', ...
        'CopyDestination', 'OverwriteDatasets'}, varargin{:});
    [fMap, copyDatasets, copyDestination, overwriteDatasets] = ...
        pop_saveheddatasets(fMap, inDir, saveheddatasetsInputArgs{:});
    saveheddatasetsOutputArgs = {'CopyDatasets', copyDatasets, ...
        'CopyDestination', copyDestination, 'OverwriteDatasets', ...
        overwriteDatasets};
    
    % Build command string
    inputArgs = [inputArgs savefmapOutputArgs saveheddatasetsOutputArgs];
else % Call function without menu % nargin > 1 && ~p.UseGui
    inputArgs = getkeyvalue({'BaseMap', 'DoSubDirs', ...
        'EventFieldsToIgnore', 'HedXml', 'PreserveTagPrefixes'}, ...
        varargin{:});
    [fMap, fPaths] = tagdir(p.InDir, inputArgs{:});
end

com = char(['pop_tagdir(' logical2str(p.UseGui) ...
    ', ' keyvalue2str(inputArgs{:}) ');']);

    function p = parseArguments(varargin)
        % Parses the input arguments and returns the results
        parser = inputParser;
        parser.addOptional('UseGui', true, @islogical);
        parser.addParamValue('BaseMap', '', @(x) isa(x, 'fieldMap') || ...
            ischar(x));
        parser.addParamValue('CopyDatasets', false, @islogical);
        parser.addParamValue('CopyDestination', '', @(x) ...
            (isempty(x) || (ischar(x))));
        parser.addParamValue('DoSubDirs', true, @islogical);
        parser.addParamValue('EventFieldsToIgnore', ...
            {'latency', 'epoch', 'urevent', 'hedtags', 'usertags'}, ...
            @iscellstr);
        parser.addParamValue('FMapDescription', '', @ischar);
        parser.addParamValue('FMapSaveFile', '', @(x)(isempty(x) || ...
            (ischar(x))));
        parser.addParamValue('HedExtensionsAllowed', false, @islogical);
        parser.addParamValue('HedXml', which('HED.xml'), @ischar);
        parser.addParamValue('InDir', '', @(x) (~isempty(x) && ischar(x)));
        parser.addParamValue('OverwriteDatasets', false, @islogical);
        parser.addParamValue('OverwriteUserHed', '', @islogical);
        parser.addParamValue('PreserveTagPrefixes', false, @islogical);
        parser.addParamValue('PrimaryEventField', 'type', @(x) ...
            (isempty(x) || ischar(x)))
        parser.addParamValue('SelectEventFields', true, @islogical);
        parser.addParamValue('SeparateUserHedFile', '', @(x) ...
            (isempty(x) || (ischar(x))));
        parser.addParamValue('UseCTagger', true, @islogical);
        parser.addParamValue('WriteFMapToFile', false, @islogical);
        parser.addParamValue('WriteSeparateUserHedFile', false, ...
            @islogical);
        parser.parse(varargin{:});
        p = parser.Results;
    end % parseArguments

end % pop_tagdir