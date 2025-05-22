%% AIM2GRoups: read table of custom mice list
[file,Location]=uigetfile('*.xlsx');
AIMsDATA=readtable([Location,file]);
COND=unique(AIMsDATA.Var1(2:end));
% Sort conditions for boxplots
%% SORT CONDITIONS GUI
CONDfil=COND;
SortCOND=[];
for n=1:numel(COND)
    f = listdlg('PromptString',{'Selecciona orden',...
    '.',''},...
    'SelectionMode','single','ListString',CONDfil);
    SortCOND=[SortCOND;CONDfil(f)];
    CONDfil=setdiff(CONDfil,CONDfil(f));
end
%% MAIN LOOP
% Colors
NameColor={'Blues','Greens','Oranges','Purples','Reds','Greys'}; %until 6 conditions

