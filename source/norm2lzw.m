function [output,table, binaryArray] = norm2lzw(vector)

global lzwMin;
lzwMin = 258;

% vector as uint16 row
vector = uint16(vector(:)');

% initialize table
table = cell(1,lzwMin);
for index = 1:lzwMin,
	table{index} = uint16(index-1);
end

% initialize output
output = vector;
biarr = [];
biarr = [biarr de2bi(lzwMin - 2, ceil(log2(lzwMin)))];

% main loop
outputindex = 1;
startindex = 1;
for index=2:length(vector)
	element = vector(index);
	substr = vector(startindex:(index-1));
	code = getCode([substr element],table);
	if isempty(code)
		% add it to the table
		output(outputindex) = getCode(substr,table);
		[table,code,flag] = addCode(table,[substr element]);
        biarr = [biarr de2bi(output(outputindex), ceil(log2(length(table) - 1)))];
        if flag == 1
            biarr = [biarr de2bi(lzwMin - 2, 12)];
            table = cell(1,lzwMin);
            for ind = 1:lzwMin,
	            table{ind} = uint16(ind-1);
            end
        end
		outputindex = outputindex+1;
		startindex = index;
	end
end

substr = vector(startindex:index);
output(outputindex) = getCode(substr,table);
biarr = [biarr de2bi(lzwMin - 1, ceil(log2(length(table) - 1)))];
binaryArray = biarr;

% remove not used positions
output((outputindex+1):end) = [];


function code = getCode(substr,table)
global lzwMin;
code = uint16([]);
if length(substr)==1,
	code = substr;
else
	for index=lzwMin + 1:length(table),
		if isequal(substr,table{index}),
			code = uint16(index-1);   % start from 0
			break
		end
	end
end


function [table,code,flag] = addCode(table,substr)
code = length(table)+1;   % start from 1
flag = 0;
if code == power(2,13)
    flag = 1;
    return;
end
table{code} = substr;
code = uint16(code-1);    % start from 0
