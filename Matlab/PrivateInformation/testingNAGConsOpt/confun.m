function [mode, c, cjac, user] = ...
    confun(mode, ncnln, n, ldcj, needc, x, cjac, nstate, user)
  c = zeros(ncnln, 1);

  if (nstate == 1)
   %  first call to confun.  set all jacobian elements to zero.
   %  note that this will only work when 'derivative level = 3'
   %  (the default; see section 11.2).
   cjac=zeros(ldcj, n);
  end

  if (needc(1) > 0)
   if (mode == 0 || mode == 2)
     c(1) = x(1)^2 + x(2)^2 + x(3)^2 + x(4)^2;
   end
   if (mode == 1 || mode == 2)
      cjac(1,1) = 2*x(1);
      cjac(1,2) = 2*x(2);
      cjac(1,3) = 2*x(3);
      cjac(1,4) = 2*x(4);
   end
  end

  if (needc(2) > 0)
   if (mode == 0 || mode == 2)
     c(2) = x(1)*x(2)*x(3)*x(4);
   end
   if (mode == 1 || mode == 2)
      cjac(2,1) = x(2)*x(3)*x(4);
      cjac(2,2) = x(1)*x(3)*x(4);
      cjac(2,3) = x(1)*x(2)*x(4);
      cjac(2,4) = x(1)*x(2)*x(3);
   end
  end