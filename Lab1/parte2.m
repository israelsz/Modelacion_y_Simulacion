% Se inicializa la variable s
s = tf('s');

% Se definen las funciones de transferencia
H1 = (4 * s) / (10 * s^2 + 4);
H2 = 3 / (6 * s + 16);
H3 = (4 * s + 10) / (4 * s^3 + 9 * s^2 + 5 * s);
H4 = 1 / (7 * s + 10);
H5 = (8 * s + 8) / (s^3 + 2 * s^2 + 3 * s);
H6 = (3 * s + 2) / (5 * s^2 + 7 * s + 10);

% Utilizando la regla de oro Y = H * U

R3 = feedback(H3, 1, +1);
Rx = R3 * parallel(H4, H5);
R6 = Rx * H6;
H = H1 + H2 + R6 %Imprime el resultado por consola

% Se grafica la respuesta al escalón para ambos lazos
graficar(H, "Respuesta al escalón para la función de transferencia resultante")