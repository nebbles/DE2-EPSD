function moves(filename, start,stop, list)
    for i = 1:(fix((stop-start+1)/length(list)))
        for j = 1:length(list)
            fprintf(filename, list(j));
            fprintf(filename, '\n');
        end
    end
     % when the set moves are not 4's or 8's:
%      if rem(length(list),4) ~= 0
%          for i = 1:rem(((stop+1)-start),length(list))
%             fprintf(filename, list(1));
%             fprintf(filename, '\n');
%          end
%      end
end