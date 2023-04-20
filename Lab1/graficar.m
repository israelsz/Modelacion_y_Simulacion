function graficar(H,titulo)
    %Se inicializa la figura
    figure
    % Se crea el gráfico de la respuesta de la función de transferencia
    % a un escalón, usando la función step()
    step(H)
    title(titulo)
    xlabel("Tiempo")
    ylabel("Amplitud")
    grid on
end

