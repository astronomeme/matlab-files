function lorenzgraph(solution,times,steps,graphs)

    if graphs == 1
        figure(1)
        title('problem 3: x vs y');
        hold on
        plot(solution(1,:),solution(2,:));
        xlabel('xvalues');
        ylabel('yvalues');
    end
    
    if graphs == 2 
        figure(2)
        title('3D plot')
        hold on
        plot3(solution(1,:), solution(2,:), solution(3,:));
        xlabel('xvalues');
        ylabel('yvalues');
        zlabel('zvalues');
        view(3);
        box on;
        for vals=1:length(steps)
           scatter3(solution(1,vals), solution(2,vals), solution(3,vals),'.');
           zlim([min(solution(3,:)),max(solution(3,:))]);
           ylim([min(solution(2,:)),max(solution(2,:))]);
           xlim([min(solution(1,:)),max(solution(1,:))]);
           drawnow
           hold on
        end
    end

    if graphs == 3
        figure(3)
        plot(solution(1,:),times);
        hold on
        ylabel('time');
        xlabel('xvalues');
        title('variable vs time');
        for vals = 1:5:length(steps)
            scatter(solution(1,vals),times(vals),'.')
            %xlim([-20,40]);
            %ylim([-20,20]);
            drawnow
            hold on
        end
    end

end