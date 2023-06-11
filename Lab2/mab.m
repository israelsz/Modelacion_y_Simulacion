% Input: Matrices A, B, C, D del modelo de estado obtenidos por funcion
%        bam
% Output: Función de transferencia del sistema.
function [H] = mab(A, B, C, D)
% Se inicializa la variable s
s = tf('s');
% Se inicializa una matriz identidad de 2x2
I = eye(2);
% Se calcula la función de transferencia
H = C * inv(s*I - A) * B + D;
end


