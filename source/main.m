prompt = 'Input video name: ';
videoName = input(prompt, 's');
v = VideoReader(videoName);

video = read(v,[1 Inf]);
rawName = v.Name(1:length(v.name) - 4);
FileName = strcat(rawName, '.gif');

s = size(video);
timePFrame = uint8(v.Duration * 100 / s(4));

colorRed = [0 32 64 96 128 160 192 224 255];
colorGreen = [0 32 64 96 128 160 192 224 255];
colorBlue = [0 64 128 192 255];
colors = zeros(1,768,'uint8');

num = 1;
for i = 2:1:9
    for j = 2:1:9
        for k = 2:1:5
            colors((num - 1) * 3 + 1) = colorRed(i);
            colors((num - 1) * 3 + 2) = colorGreen(j);
            colors((num - 1) * 3 + 3) = colorBlue(k);
            num = num + 1;
        end
    end
end

indexTable = zeros(s(1),s(2),s(4),'uint8');

for i = 1:1:s(1)
    for j = 1:1:s(2)
        for k = 1:1:s(4)
            ir = 1;
            while video(i,j,1,k) >= colorRed(ir) && ir <= 8
                ir = ir + 1;
            end
            ig = 1;
            while video(i,j,2,k) >= colorGreen(ig) && ig <= 8
                ig = ig + 1;
            end
            ib = 1;
            while video(i,j,3,k) >= colorBlue(ib) && ib <= 4
                ib = ib + 1;
            end
            indexTable(i,j,k) = (ir-2)*32+(ig-2)*4+ib-2;
            
        end
    end
end

file = fopen(FileName, 'w');

Header = [71 73 70 56 57 97];
fwrite(file, Header);

ScreenDescriptor = [bitand(s(2), 255), bitshift(s(2), -8), bitand(s(1), 255) - 1,... 
                    bitshift(s(1), -8), 247, 0, 0];
fwrite(file, ScreenDescriptor);
fwrite(file, colors);

AppExtensionBlock = [33 255 11 78 69 84 83 67 65 80 69 50 46 48 3 1 0 0 0];
fwrite(file, AppExtensionBlock);

GraphicControlExtension = [33 249 4 4 timePFrame 0 0 0];

imageDescriptor = [44,0,0,0,0,bitand(s(2), 255), bitshift(s(2), -8), bitand(s(1), 255),... 
      bitshift(s(1), -8), 0];

for k = 1:1:s(4)
    DataStream = [8];
    frame = transpose(indexTable(:,:,k));
    [lzw, table, binaryArray] = norm2lzw(uint8(frame));
    len = 1;
    num = [];
    while length(binaryArray) >= 8
        num(len) = bi2de(binaryArray(1:8));
        len = len + 1;
        if len == 256
            DataStream = [DataStream 255 num];
            num = [];
            len = 1;
        end
        binaryArray  = binaryArray(9:length(binaryArray));
        if length(binaryArray) < 8 && length(binaryArray) ~= 0
            num(len) = bi2de(binaryArray(1:length(binaryArray)));
        end  
    end
    if length(num) ~= 0
        DataStream = [DataStream length(num) num 0];
    end
     
    fwrite(file, GraphicControlExtension);
    fwrite(file, imageDescriptor);
    fwrite(file, DataStream);
end

Trailer = 59;
fwrite(file, Trailer);

fclose(file);


