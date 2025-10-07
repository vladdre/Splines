function [x, y] = parse_data(filename)
    
  % Se deschide fisierul de citire
  fid = fopen(filename, 'r');

  % Se citeste lungimea fiecarui vector
  lungime = fscanf(fid, '%d', 1);
  % Se adauga 1 pentru ca sunt lungime + 1 elemente in cei 2 vectori
  lungime = lungime + 1;

  % Citim abscisele punctelor interpolarii suport
  x = fscanf(fid, '%d', lungime);
  % Citim ordonatele punctelor interpolarii suport
  y = fscanf(fid, '%d', lungime);

  % Se inchide fisierul de citire
  fclose(fid);
    
end