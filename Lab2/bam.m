% Input: Valores de a, b, c, d, e, f para formar a H1 y H2.
% Output: Matrices del modelo de estado.
function [A, B, C, D] = bam(a, b, c, d, e ,f)
% Se generan las matrices del modelo de estado, de acuerdo al calculo
% algebraico realizado para el diagrama.
A = [c/b -a/b; d/e f/e];
B = [a/b; 0];
C = [1 0];
D = [0; 0];
end

