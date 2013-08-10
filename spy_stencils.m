
function [] = spy_stencils(stencil_list_in,is_from_cpp)

if nargin < 1
   is_from_cpp = 0;  
end

if is_from_cpp
   stencil_list = stencil_list_in(:,2:end) + 1; 
else 
    stencil_list = stencil_list_in; 
end

% Show the spy(stencil_list) to see sparsity patterns
s = figure; 
N = size(stencil_list, 1); 
st = size(stencil_list,2); 
A = spalloc(N, N, st * N);
for i = 1:N
%    for j = 1:st
        A(i,stencil_list(i,1:st)) = 1; 
    %end
end
set(gca, 'FontSize', 18);
spy(A, 5)
set(gcf,'Position',[100 100 700 650])
%plot_pos = get(gca,'Position');
set(gca,'Unit','normalized','Position',[0.15 0.125 0.825 0.8],'XTickLabelMode', 'auto');

% Print to EPS with "print -depsc test.eps" 

end
