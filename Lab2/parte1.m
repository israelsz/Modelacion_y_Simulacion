% Se asignan valores para a, b, c, d, e y f
a = 5;
b = 3;
c = 1;
d = 7;
e = 2;
f = 4;

% Se inicializa la variable s
s = tf('s');
% Se consiguen las funciones de transferencia de la figura
H1 = a/(b*s - c);
H2 = d/(e*s - f);

% Se consiguen las matrices del modelo de estado usando la función bam()
[A, B, C, D] = bam(a, b, c, d, e, f);
% Se calcula la función de transferencia ocupando la función mab()
H = mab(A, B, C, D);

respuestaH = step(H(1)); % Respuesta al escalon de H

respuestaH1H2 = step(feedback(H1, H2)); %Respuesta al escalon de H1 y H2

% Gráfico comparativo respuestas entre mab - Lazo cerrado de H1 y H2
plot ( respuestaH, "r *");
title ("Comparación de funciones de transferencia");
ylabel ("H(s)");
xlabel ("Tiempo [s]");
hold on;
plot (respuestaH1H2, "b--o");
legend("H(s) obtenido con mab","H(s) de feedback (H1, H2)")
grid;
hold off;
