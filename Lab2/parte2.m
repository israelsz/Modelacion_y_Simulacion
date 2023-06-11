%Parte 2 laboratorio 2 Modelacion y simulacion

%Definicion de las matrices que componen el modelo de estado obtenido
A = [ -15 10; 5 -15/2];
B = [1/2; 1/4];
C = [1 0; 0 1];
D = [0; 0];

%Se define el modelo de estado con las matrices definidas
M = ss(A, B, C, D);

%Se define la entrada del sistema u(t)
t = linspace(0, 12*pi, 5000);
u = 100*sin(t/4);
u(u<0) = 0.;

%Se crea un grafico para contener los subgraficos de la respuesta frente
%a cada entrada diferente 
figure;

% Resultado ante un escalón
subplot(3,1,1);
step(M);
grid on;
title('Resultado frente un escalón');
ylabel('Amplitud')
xlabel('Tiempo')

% Resultado ante un impulso
subplot(3,1,2);
impulse(M);
grid on;
title('Resultado frente un impulso');
ylabel('Amplitud')
xlabel('Tiempo')

% Resultado ante función u(t)
subplot(3,1,3);
lsim(M, u, t);
grid on;
title('Resultado frente u(t) = 100*Sen(t/4)');
ylabel('Amplitud')
xlabel('Tiempo')

sgt = sgtitle('Resultado del sistema');
sgt.FontSize = 20;