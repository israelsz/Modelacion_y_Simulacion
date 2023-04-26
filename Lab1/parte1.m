% Se inicializa la variable s
s = tf('s');

%% ------- Ecuación 1 -------
% Se escribe la función de transferencia obtenida
H1 = (4*s) / (3*s + 1);

% Lazo Abierto
H1o = H1;
% Lazo Cerrado
H1c = feedback(H1,1,-1);

% Calculo de polos y ceros para lazo abierto
ceros_H1o = zero(H1o);
polos_H1o = pole(H1o);

% Calculo de polos y ceros para lazo cerrado
ceros_H1c = zero(H1c);
polos_H1c = pole(H1c);

% Calculo de la ganancia estática
ganancia_H1o = dcgain(H1o);
ganancia_H1c = dcgain(H1c);

% Calculo tiempo de estabilización
stabletime_H1o = stepinfo(H1o).SettlingTime;
stabletime_H1c = stepinfo(H1c).SettlingTime;

% Se grafica la respuesta al escalón para ambos lazos
graficar(H1o, "Respuesta al escalón en Lazo Abierto para 1° Ecuación")
graficar(H1c, "Respuesta al escalón en Lazo Cerrado para 1° Ecuación")

%% ------- Ecuación 2 -------
% Se escribe la función de transferencia obtenida
H2 = (5*s^2 + 7*s + 1) / (s^2 + 6*s + 3);

% Lazo Abierto
H2o = H2;
% Lazo Cerrado
H2c = feedback(H2,1,-1);

% Calculo de polos y ceros para lazo abierto
ceros_H2o = zero(H2o);
polos_H2o = pole(H2o);

% Calculo de polos y ceros para lazo cerrado
ceros_H2c = zero(H2c);
polos_H2c = pole(H2c);

% Calculo de la ganancia estática
ganancia_H2o = dcgain(H2o);
ganancia_H2c = dcgain(H2c);

% Calculo tiempo de estabilización
stabletime_H2o = stepinfo(H2o).SettlingTime;
stabletime_H2c = stepinfo(H2c).SettlingTime;

% Se grafica la respuesta al escalón para ambos lazos
graficar(H2o, "Respuesta al escalón en Lazo Abierto para 2° Ecuación")
graficar(H2c, "Respuesta al escalón en Lazo Cerrado para 2° Ecuación")

%% Imprimir tabla resumen
Funcion = ["Función 1"; "Función 1"; "Función 2"; "Función 2"];
Lazo = ["Lazo Abierto"; "Lazo Cerrado"; "Lazo Abierto"; "Lazo Cerrado"];
Ceros = [ceros_H1o; ceros_H1c; sprintf("%d ; %d",ceros_H2o); sprintf("%d ; %d",ceros_H2c)];
Polos = [polos_H1o; polos_H1c; sprintf("%d ; %d",polos_H2o); sprintf("%d ; %d",polos_H2c)];
GananciaEstatica = [ganancia_H1o; ganancia_H1c; ganancia_H2o; ganancia_H2c];
TiempoEstabilizacion = [stabletime_H1o; stabletime_H1c; stabletime_H2o; stabletime_H2c];
disp("---------------Tabla Resumen---------------")
Tabla = table(Funcion, Lazo, Ceros, Polos, GananciaEstatica, TiempoEstabilizacion)


