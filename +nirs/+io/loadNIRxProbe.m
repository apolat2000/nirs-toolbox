function probe = loadNIRxProbe(folder,registerprobe)
% This function loads a NIRx probe


if(nargin<2)
    registerprobe=false;  % flag to also do 3D registration
end


if(~isdir(folder))
    folder=fileparts(folder);
end


%now read the probeInfo file and convert to a probe class
file = dir(fullfile(folder,'*robeInfo.mat'));
if(isempty(file)); raw=[]; return; end;

load(fullfile(folder,file(1).name)); % --> probeInfo








% fix for older versions
if(~isfield(probeInfo.probes,'labels_s'))
    
    lst=find(probeInfo.probes.index_s(:,2)<0);
    for i=1:length(lst)
        name=['MNI:['   num2str(probeInfo.probeInfo.probes.coords_s3(lst(i),1)) ',' ...
            num2str(probeInfo.probeInfo.probes.coords_s3(lst(i),2)) ',' ...
            num2str(probeInfo.probeInfo.probes.coords_s3(lst(i),3)) ']'];
        
        probeInfo.geom.NIRxHead.ext1020sys.labels{end+1}=name;
        probeInfo.probes.index_s(lst(i),2)=length(probeInfo.geom.NIRxHead.ext1020sys.labels);
    end
    lst=find(probeInfo.probes.index_d(:,2)<0);
    for i=1:length(lst)
        name=['MNI:['   num2str(probeInfo.probeInfo.probes.coords_d3(lst(i),1)) ',' ...
            num2str(probeInfo.probeInfo.probes.coords_d3(lst(i),2)) ',' ...
            num2str(probeInfo.probeInfo.probes.coords_d3(lst(i),3)) ']'];
        
        probeInfo.geom.NIRxHead.ext1020sys.labels{end+1}=name;
        probeInfo.probes.index_d(lst(i),2)=length(probeInfo.geom.NIRxHead.ext1020sys.labels);
    end
    
    
    probeInfo.probes.labels_s= {probeInfo.geom.NIRxHead.ext1020sys.labels{probeInfo.probes.index_s(:,2)}};
    probeInfo.probes.labels_d= {probeInfo.geom.NIRxHead.ext1020sys.labels{probeInfo.probes.index_d(:,2)}};
end


SrcPos2D = probeInfo.probes.coords_s2;
SrcPos2D(:,3)=0;
DetPos2D = probeInfo.probes.coords_d2;
DetPos2D(:,3)=0;
% FID2D    = probeInfo.probes.coords_c2;
% FID2D(:,3)=0;


XYZ2D = [SrcPos2D; DetPos2D]; % FID2D];

SrcPos3D = probeInfo.probes.coords_s3*10;
DetPos3D = probeInfo.probes.coords_d3*10;
%FID3D    = probeInfo.probes.coords_c3*10;
XYZ3D = [SrcPos3D; DetPos3D]; % FID3D];


cnt=1; Name={}; Type={};
for i=1:size(SrcPos2D,1)
    s=['000' num2str(i)];
    Name{cnt,1}=['Source-' s(end-3:end)];
    Type{cnt,1}='Source';
    cnt=cnt+1;
end
for i=1:size(DetPos2D,1)
    s=['000' num2str(i)];
    Name{cnt,1}=['Detector-' s(end-3:end)];
    Type{cnt,1}='Detector';
    cnt=cnt+1;
end
% for i=1:size(FID2D,1)
%     s=['000' num2str(i)];
%     Name{cnt,1}=['FID-' s(end-3:end)];
%     Type{cnt,1}='FID-anchor';
%     cnt=cnt+1;
% end

optodes2D = table(Name, [SrcPos2D(:,1); DetPos2D(:,1)],...
    [SrcPos2D(:,2); DetPos2D(:,2)],...
    [SrcPos2D(:,3); DetPos2D(:,3)],...
    Type,repmat({'mm'},cnt-1,1),...
    'VariableNames',{'Name','X','Y','Z','Type','Units'});


optodes3D = table(Name, [SrcPos3D(:,1); DetPos3D(:,1)],...
    [SrcPos3D(:,2); DetPos3D(:,2)],...
    [SrcPos3D(:,3); DetPos3D(:,3)],...
    Type,repmat({'mm'},cnt-1,1),...
    'VariableNames',{'Name','X','Y','Z','Type','Units'});

fid2D = table({probeInfo.probes.labels_s{:} probeInfo.probes.labels_d{:}}', ...
    [SrcPos2D(:,1); DetPos2D(:,1)],...
    [SrcPos2D(:,2); DetPos2D(:,2)],...
    [SrcPos2D(:,3); DetPos2D(:,3)],...
    repmat({'FID-anchor'},probeInfo.probes.nDetector0+probeInfo.probes.nSource0,1),...
    repmat({'mm'},probeInfo.probes.nDetector0+probeInfo.probes.nSource0,1),...
    'VariableNames',{'Name','X','Y','Z','Type','Units'});


fid3D = table({probeInfo.probes.labels_s{:} probeInfo.probes.labels_d{:}}', ...
    [SrcPos3D(:,1); DetPos3D(:,1)],...
    [SrcPos3D(:,2); DetPos3D(:,2)],...
    [SrcPos3D(:,3); DetPos3D(:,3)],...
    repmat({'FID-anchor'},probeInfo.probes.nDetector0+probeInfo.probes.nSource0,1),...
    repmat({'mm'},probeInfo.probes.nDetector0+probeInfo.probes.nSource0,1),...
    'VariableNames',{'Name','X','Y','Z','Type','Units'});
                    

[lst,i]=ismember(fid2D(:,2:end),optodes2D(:,2:end));


optodes2D=[optodes2D; fid2D];
optodes3D=[optodes3D; fid3D];




if(registerprobe)
    BEM = nirs.registration.Colin27.mesh_V2;
else
    BEM = nirs.registration.NIRxGeom.mesh;
end

[T,optodes3D]=nirs.registration.cp2tform(optodes3D,BEM(1).fiducials,true);


probe=nirs.core.Probe1020;
probe.optodes=optodes2D;
probe.optodes_registered=optodes3D;
probe=probe.set_mesh(BEM);

link=table(probeInfo.probes.index_c(:,1),probeInfo.probes.index_c(:,2),...
    'VariableNames',{'source','detector'});
probe.link=link;


end

