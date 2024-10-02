function Xtable = readdlctableLID(filename, dataLines)

BODYPARTS={'UpX';
    'UpY';	
    'UpL';	
    'DownX';	
    'DownY';	
    'DownL';
    'LeftX';
    'LeftY';
    'LeftL';
    'RightX';
    'RightY';
    'RightL';
    'TailX';
    'TailY';
    'TailL';
    'CenterX';
    'CenterY';
    'CenterL';
    'NoseX';
    'NoseY';
    'NoseL';
    'LeftBackX';
    'LeftBackY';
    'LeftBackL';
    'LeftUpX';
    'LeftUpY';
    'LeftUpL';
    'RightBackX';
    'RightBackY';
    'RightBackL';
    'RightUpX';
    'RightUpY';
    'RightUpL'};

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [4, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 61);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ['FRAME';BODYPARTS];
opts.VariableTypes = repmat({'double'},1,size(BODYPARTS,1)+1);

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Xtable = readtable(filename, opts);

% end