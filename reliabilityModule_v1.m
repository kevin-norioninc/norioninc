%%Reliability Module v1 
% Copyright 2016, Norion, Inc.

%%Change Log
% KBN - 13 March 2016 : Created 
% KBN - 17MAR16 : Generalize

clear all
close all

%%Reliability: Is the data COMPLETE for the purpose to which we wish to employ it?
%To help ith this question we need measure that speak to completness

%FIRST: Read in some data. Use IMPORT tool to make a table of the data
%generate code function or reading using the import tool
FILENAME = 'C:\Users\cedge\Desktop\Norion\NorionSourceCode\sample.csv';
dataSetTable = importfile1(FILENAME); 

%%Now we have some data in a table called: dataSet
%Put out some metrics, how much data do we have, how is it grouped. 
dataSetHeight = height(dataSetTable)  %number of rows of the table
dataSetWidth = width(dataSetTable)  %number of variables in the table

%use data as an arrary
dataSetArray = table2array(dataSetTable); %numerical array

%Start with a histogram of each column
for j = 1:dataSetWidth
    displayVariable = dataSetArray(:,j);
    h = histogram(displayVariable);
    h.NumBins
    if h.NumBins > 10
         figure;
         histogram(displayVariable);
    end
end

%for example in RADAR this might be amplitude of a channel recievers. 


%For a CNN, plot reliability 
% Ingest raw confidence values and other parameters
totalSize = 30000;
sampleSize = 6000;

dataLabels = {'Cylindrical', 'Empty', 'Manta', 'Rock','Tethered'};
detectionList = [5628 5904 5124 5532 6000];
%detectionList = [5128 6204 6200 5832 6000];
rawConfidence = [93.8 98.4 85.4 92.2 100];
%detectionList = [3000];
%rawConfidence = [100];

dataCube = [dataLabels detectionList rawConfidence];

%Scale the Confidence - operate on the vector as a whole rather than by elm
scaledConfidence = rawConfidence/100;

%Calcuate fraction of positives for each given confidence 
fracPos = detectionList/sampleSize; %how many there really where?;

%Calculate Mean Predicted Values (add up the numbers and divide by how many
meanConfidence = mean(scaledConfidence);

%sort the data for display purposes, would be better as a function!
x = fracPos;
y = scaledConfidence;
sorted=sortrows([x' y']);
sorted_x = sorted(:,1);
sorted_y = sorted(:,2);
fracPos = sorted_x;
scaledConfidence = sorted_y;


fig = figure('Visible','on','Menubar', 'none','ToolBar', 'none'); %generate figure window

scatter(fracPos,scaledConfidence,25,'b','*')
%a = [1:10]'; b = num2str(a); 
%c = cellstr(b);
dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
text(fracPos+dx, scaledConfidence+dy, dataLabels);

line (fracPos,scaledConfidence)
%plot(fracPos, scaledConfidence);  %the fraction of postives report vs the scaled mean of confidence
ideal = refline([1 0]);%display calibrated "ideal" line
ideal.Color = 'k';    
xlim = ([0 1]);
ylim = ([0 1]);

%show the mean in red
hline = refline([0 meanConfidence]);
hline.Color = 'r';

title('Reliability Diagram'); 
xlabel('Scaled Confidence (Normalized Mean)');
ylabel('Fraction of Positives');       








