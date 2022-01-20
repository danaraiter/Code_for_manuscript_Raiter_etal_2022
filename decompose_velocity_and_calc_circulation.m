function strf_Hadley = decompose_and_strf_calc(u_mean,v_mean)
level = [1,5,10,20,30,50,70,100,150,200,250,300,400,500,600,700,800,925,1000]';

load('laplacian_interp.mat');
long = 0:2:358;
lat = -90:2:90;
lat = flipud(lat');
level_pa = level.*100;
lat_new=lat(2:end-1);
N=length(lat_new);
M=length(long);
r = 6378100; %meters
theta = abs(lat-90);
phi = theta;
dtheta = -(2/180)*pi;
dphi = (2/180)*pi;
dlambda = (2/180)*pi;
%%
D = zeros(size(v_mean,1),size(v_mean,2),size(v_mean,3),size(v_mean,4));
for k=1:length(level)
    for j=2:N-1
        for i=1:M
             if i==1
                  delphi = -(v_mean(i,j+1,k,:)*sind(phi(j+1))-v_mean(i,j-1,k,:)*sind(phi(j-1)))/(2*dphi);
               D(1,j,k,:) = (1/(r*sind(phi(j)))) * (u_mean(2,j,k,:) - u_mean(M,j,k,:))/(2*dlambda)+ ((1/(r*sind(phi(j)))) * (delphi));
            else if i==M 
                    delphi = -(v_mean(i,j+1,k,:)*sind(phi(j+1))-v_mean(i,j-1,k,:)*sind(phi(j-1)))/(2*dphi);
               D(M,j,k,:) = (1/(r*sind(phi(j)))) * (u_mean(1,j,k,:) - u_mean(M-1,j,k,:))/(2*dlambda)+...
                   (1/(r*sind(phi(j)))) * (delphi);
                else
%if i~=1 && i~=M
               dellambda = (u_mean(i+1,j,k,:)-u_mean(i-1,j,k,:))/(2*dlambda);
               delphi =-(v_mean(i,j+1,k,:,:)*sind(phi(j+1))-v_mean(i,j-1,k,:)*sind(phi(j-1)))/(2*dphi);
            D(i,j,k,:) = 1/(r*sind(phi(j))) * (dellambda + delphi);
                 end
              end
    end
end
end
%%
      temp= D;
D = temp(:,2:end-1,:,:);


for i = 1:length(level)
D_reshaped(:,i) = reshape((D(:,:,i))',N*M,1);
end





%%




xi(:,:)= A\(D_reshaped(:,:));

%%
xi_mat = zeros(N+2,M,length(level));

for k=1:length(level)
  for i=1:N
     for j=1:M
        n=i+(j-1)*N;
        xi_mat(i,j,k) = xi(n,k);
     end
  end
end

  xi_mat=permute(xi_mat,[2 1 3]);    
  %%
 
  
  for k=1:length(level)
      for j = 1:N
          for i = 1:M
              if j==1
                 del_theta = (xi_mat(i,j+1,k,:) - xi_mat(i,j,k,:))/(dtheta); 
              
              else if j == N
                   del_theta = (xi_mat(i,j,k,:) - xi_mat(i,j-1,k,:))/(dtheta); 
                   else
              del_theta = (xi_mat(i,j+1,k,:) - xi_mat(i,j-1,k,:))/(2*dtheta);
                  end
              end
              if i == 1
                   del_phi = (xi_mat(i+1,j,k,:) - xi_mat(i,j,k,:))/(dphi);
              else if i == M
                    del_phi = (xi_mat(i,j,k,:) - xi_mat(i-1,j,k,:))/(dphi); 
                  else
              del_phi = (xi_mat(i+1,j,k,:) - xi_mat(i-1,j,k,:))/(2*dphi);
                  end
              end
              v_div_phi(i,j,k,:) = (1/(r*sind(theta(j)))) * del_phi;
              v_div_theta(i,j,k,:) = (1/r) * del_theta;
           
          end
      end
  end
u_rot = u_mean(:,2:end-1,:)-v_div_phi;
v_rot = v_mean(:,2:end-1,:)-v_div_theta;

%%
lat=double(lat);

num_lev=length(level_pa);
  level_half(2:length(level_pa))=(level_pa(2:end)+level_pa(1:end-1))./2;
  level_half(num_lev+1)=level_pa(end);
  level_half(1)=0;%level(end)/2;
  weight=double(level_half(2:end)-level_half(1:end-1));
 
  

%v_mean=squeeze(nanmean(v_div_theta,1));
v_mean = v_div_theta;


   stream=zeros(size(v_mean,1),size(v_mean,2),size(v_mean,3),size(v_mean,4));
 % A=cosd(lat_new)';

v_mean1=v_mean; %.*repmat(A,[192 1 length(level_pa)]);

for k=1:length(level)
    if k==1
        stream(:,:,k,:)=v_mean1(:,:,k,:).*weight(k);
    else
    stream(:,:,k,:)=stream(:,:,k-1,:)+v_mean1(:,:,k,:).*weight(k);
    end
end

stream=stream./9.81;
strf_Hadley = stream;
end