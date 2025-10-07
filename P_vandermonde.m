% Sursa de inspiratie: Tema2 MN Task2 Vandermonde Interpolation
function y_interp = P_vandermonde (coef, x_interp)

  % Extragem lungimea lui x_interp
  lungime = length(x_interp);

  % Luam fiecare element din x_interp
  for i = 1:lungime
    % Initializam x_Vandermonde ca fiind gol
    x_Vandermonde = [];
    % Initializam putere cu 0
    putere = 0;
    % Facem un for pentru a completa x_Vandermonde
    for j = 1:length(coef)
      % Punem pe in pozitia j pe x_interp(i) la puterea putere
      x_Vandermonde(1, j) = x_interp(i) ^ putere;
      % Marim cu 1 putere
      putere = putere + 1;
    endfor

    % Punem in y_interp rezultatul (numarul) inmultirii
    % Intre vectorul linie x_Vandermonde si vectorul coloana coef
    y_interp(i) = x_Vandermonde * coef;
  endfor

end
