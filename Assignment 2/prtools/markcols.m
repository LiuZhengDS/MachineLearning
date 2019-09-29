%MARKCOLS Randomly change marker colors in lineplot or scatterplot
%
%	 COLS = MARKCOLS  get colors of lines and markers
%  MARKCOLS(COLS)   set colors of lines and markers
%  MARKCOLS         Randomly rotate colors of lines and markers
% 
function out = markcols(cols)

  n = 0;
  h = get(gca,'Children')';
  line = false(1,numel(h));
  for i = h
    n = n+1;
    if strcmp(get(i,'Type'),'line')
      line(n) = true;
    end
  end
  L = find(line);

  if nargin == 0

    cols = zeros(numel(L),3);
    for i = 1:numel(L)
      cols(L(i),:) = get(h(L(i)),'Color');
    end

    if nargout == 0
      R = randperm(numel(L));
      for i=1:numel(L)
        set(h(L(i)),'Color',cols(R(i),:));
      end
    else
      out = cols;
    end

  else
    for i=1:min(numel(L),size(cols,1))
      set(h(L(i)),'Color',cols(i,:));
    end

  end
  



