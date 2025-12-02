function InterfazCampoMagnetico()
    % Proyecto de Josafat Vásquez (9-764-2024)
    % Profesor: Francisco Pineda
% ---------- FIGURA PRINCIPAL -----------------------------------------
fig = uifigure('Name','Campo Magnético', ...
    'Position',[100 100 1250 640], ...
    'Color',[0.93 0.96 1]);

uilabel(fig,'Text','Campo Magnético', ...
    'FontSize',20,'FontWeight','bold', ...
    'HorizontalAlignment','center', ...
    'FontColor',[0.1 0.2 0.4], ...
    'Position',[300 590 650 30]);

% ---------- SELECCIÓN DE FUENTE --------------------------------------
uilabel(fig,'Text','Tipo de Fuente:', ...
    'Position',[30 550 110 22], ...
    'FontWeight','bold','FontColor',[0.1 0.2 0.4]);
menuFuente = uidropdown(fig,'Items',{'Espiras','Líneas'}, ...
    'Position',[140 550 160 25], ...
    'BackgroundColor',[0.85 0.91 1], ...
    'FontColor',[0.1 0.2 0.4]);

% ---------- PANEL DE PARÁMETROS --------------------------------------
pnl = uipanel(fig,'Title','⚙ Parámetros de Entrada', ...
    'FontSize',14,'FontWeight','bold', ...
    'Position',[20 140 320 400], ...
    'BackgroundColor',[0.85 0.91 1]);

% ---------- BOTÓN GRAFICAR -------------------------------------------
btnGraficar = uibutton(fig,'Text','📈 Graficar Campo', ...
    'Position',[100 80 160 38], ...
    'FontWeight','bold','FontSize',13, ...
    'BackgroundColor',[0.2 0.45 0.8], ...
    'FontColor','white');

% ---------- EJE 3‑D ---------------------------------------------------
ax = uiaxes(fig,'Position',[370 60 850 500], ...
    'BackgroundColor',[0.95 0.97 1]);
ax.XColor = [0.1 0.2 0.4]; ax.YColor = ax.XColor; ax.ZColor = ax.XColor;
view(ax,3); grid(ax,'on');
title(ax,'Distribución del Campo Magnético', ...
    'FontSize',14,'FontWeight','bold','Color',[0.1 0.2 0.4]);

% ---------- FIRMA -----------------------------------------------------
uilabel(fig,'Text','Josafat Vásquez', ...
    'FontSize',12,'FontWeight','bold', ...
    'FontColor',[0.6 0.7 0.9], ...
    'Position',[1100 10 130 20], ...
    'HorizontalAlignment','right');

% ---------- STRUCT PARA CAMPOS DINÁMICOS -----------------------------
fig.UserData.campos = struct();

% ---------- CALLBACKS -------------------------------------------------
menuFuente.ValueChangedFcn = @(src,event) actualizarCampos(pnl,menuFuente.Value);
btnGraficar.ButtonPushedFcn  = @(src,event) graficar(menuFuente.Value,ax);

% ---------- CREAR CAMPOS INICIALES ------------------------------------
actualizarCampos(pnl,'Espiras');

% ----------------- FUNCIONES ANIDADAS --------------------------------

    function actualizarCampos(panel,tipo)
        delete(panel.Children);
        fig.UserData.campos = struct();

        % Campos comunes (malla y límites)
        yBase = 40;  % desplazamiento vertical para los campos comunes

        % Malla 
        uilabel(panel,'Text','Puntos XY:', 'Position',[10 yBase+280 100 22]);
        campos.Nxy = uieditfield(panel,'numeric','Value',15, ...
            'Limits',[5 100],'Position',[120 yBase+280 80 22]);

        uilabel(panel,'Text','Puntos Z:', 'Position',[10 yBase+250 100 22]);
        campos.Nz = uieditfield(panel,'numeric','Value',30, ...
            'Limits',[5 150],'Position',[120 yBase+250 80 22]);

        % Factores de límite 
        uilabel(panel,'Text','Factor XY:', 'Position',[10 yBase+210 100 22]);
        campos.facXY = uieditfield(panel,'numeric','Value',3, ...
            'Limits',[0.5 10],'Position',[120 yBase+210 80 22]);

        uilabel(panel,'Text','Factor Z:', 'Position',[10 yBase+180 100 22]);
        campos.facZ = uieditfield(panel,'numeric','Value',1.5, ...
            'Limits',[0.5 10],'Position',[120 yBase+180 80 22]);

        if strcmp(tipo,'Espiras')
            % Espiras 
            campos.N  = uieditfield(panel,'numeric','Position',[120 yBase+130 80 22],'Value',5);
            uilabel(panel,'Text','Nº espiras:','Position',[10 yBase+130 100 22]);

            campos.d  = uieditfield(panel,'numeric','Position',[120 yBase+100 80 22],'Value',0.05);
            uilabel(panel,'Text','Distancia d:','Position',[10 yBase+100 100 22]);

            campos.R  = uieditfield(panel,'numeric','Position',[120 yBase+70 80 22],'Value',0.1);
            uilabel(panel,'Text','Radio R:','Position',[10 yBase+70 100 22]);

            campos.I  = uieditfield(panel,'numeric','Position',[120 yBase+40 80 22],'Value',1);
            uilabel(panel,'Text','Corriente I:','Position',[10 yBase+40 100 22]);

            campos.modo = uidropdown(panel,'Items',{'Normal','Unitario'}, ...
                'Position',[120 yBase+10 80 22]);
            uilabel(panel,'Text','Modo:','Position',[10 yBase+10 100 22]);

            campos.visual = uidropdown(panel,'Items',{'Vectores','Líneas curvas'}, ...
                'Position',[220 yBase+10 90 22]);
            uilabel(panel,'Text','Visual:','Position',[220 yBase+40 90 22]);

        else
            % Líneas
            campos.numLineas = uieditfield(panel,'numeric','Value',1, ...
                'Limits',[1 Inf],'RoundFractionalValues',true, ...
                'Position',[120 yBase+130 80 22]);
            uilabel(panel,'Text','Cant. Líneas:','Position',[10 yBase+130 100 22]);

            campos.tbl = uitable(panel,'Data',zeros(1,7), ...
                'ColumnEditable',true(1,7), ...
                'ColumnName',{'x0','y0','z0','x1','y1','z1','I'}, ...
                'Position',[10 40 300 90]);

            campos.numLineas.ValueChangedFcn = @(s,e) ...
                set(campos.tbl,'Data',zeros(s.Value,7));

            campos.modo = uidropdown(panel,'Items',{'Normal','Unitario'}, ...
                'Position',[220 yBase+280 100 22]);
            uilabel(panel,'Text','Modo:','Position',[220 yBase+300 90 22]);
        end

        fig.UserData.campos = campos;
    end

    % GRAFICAR
    function graficar(tipo,ax)
        campos = fig.UserData.campos;
        cla(ax); hold(ax,'on'); grid(ax,'on'); view(ax,3);

        % Malla y límites deseados
        Nxy   = campos.Nxy.Value;
        Nz    = campos.Nz.Value;
        facXY = campos.facXY.Value;
        facZ  = campos.facZ.Value;

        if strcmp(tipo,'Espiras')
            % ------- leer parámetros de espiras -------
            N  = campos.N.Value;  d = campos.d.Value;
            R  = campos.R.Value;  I = campos.I.Value;
            modo   = lower(campos.modo.Value);
            visual = campos.visual.Value;
            plotCampoEspiras(N,d,R,I,modo,visual,ax,Nxy,Nz,facXY,facZ);
        else
            % ------- leer parámetros de líneas -------
            datos = campos.tbl.Data;   modo = lower(campos.modo.Value);
            plotCampoLineas(datos,modo,ax,Nxy,Nz,facXY,facZ);
        end
        hold(ax,'off');
    end
end

function plotCampoEspiras(N,d,R,I,modo,tipoVisual,ax,Nxy,Nz,facXY,facZ)
mx = linspace(-facXY*R, facXY*R, Nxy);
my = mx;
mz = linspace(-facZ*N*d, facZ*N*d, Nz);
[X,Y,Z] = meshgrid(mx,my,mz);
Hx = zeros(size(X)); Hy = Hx; Hz = Hx;

theta = linspace(0,2*pi,1000); dtheta = theta(2)-theta(1);
cosT = cos(theta); sinT = sin(theta);

for n = 1:N
    z0 = (n-1)*d - (N-1)*d/2;
    x_c = R*cosT;       y_c = R*sinT;     z_c = z0;
    dlx = -R*sinT*dtheta;  dly = R*cosT*dtheta; dlz = 0;
    for k = 1:numel(theta)
        Rx = X - x_c(k); Ry = Y - y_c(k); Rz = Z - z_c;
        Rmag = sqrt(Rx.^2 + Ry.^2 + Rz.^2); Rmag(Rmag==0)=eps;
        coef = I/(4*pi)./Rmag.^3;
        Hx = Hx + coef .* (dly(k).*Rz - dlz.*Ry);
        Hy = Hy + coef .* (dlz.*Rx - dlx(k).*Rz);
        Hz = Hz + coef .* (dlx(k).*Ry - dly(k).*Rx);
    end
end

if strcmpi(modo,'unitario')
    mag = sqrt(Hx.^2 + Hy.^2 + Hz.^2); mag(mag==0)=1;
    Hx = Hx./mag; Hy = Hy./mag; Hz = Hz./mag;
end

cla(ax); hold(ax,'on');
plot_theta = linspace(0,2*pi,1000);
for n = 1:N
    z0 = (n-1)*d - (N-1)*d/2;
    plot3(ax,R*cos(plot_theta),R*sin(plot_theta),z0*ones(size(plot_theta)), ...
        'r','LineWidth',1);
end

switch lower(tipoVisual)
    case 'líneas curvas'
        [sx,sy,sz] = meshgrid(linspace(-1.2*R,1.2*R,6), ...
                              linspace(-1.2*R,1.2*R,6), ...
                              linspace(-facZ*N*d,facZ*N*d,6));
        streamline(ax,X,Y,Z,Hx,Hy,Hz,sx,sy,sz);
    otherwise
        quiver3(ax,X,Y,Z,Hx,Hy,Hz,'Color','b','AutoScale','on', ...
            'AutoScaleFactor',0.7,'LineWidth',0.8,'MaxHeadSize',0.5);
end
axis(ax,'tight'); xlabel(ax,'x [m]'); ylabel(ax,'y [m]'); zlabel(ax,'z [m]');
view(ax,3); grid(ax,'on');
title(ax,sprintf('Campo H de %d espira(s), I = %.3f A',N,I));
end

% ================== FUNCIÓN LÍNEAS ===================================
function plotCampoLineas(data,modo,ax,Nxy,Nz,facXY,facZ)
if isempty(data); return; end
all_pts = [data(:,1:3); data(:,4:6)];
min_c = min(all_pts) - 1; max_c = max(all_pts) + 1;
span  = max_c - min_c;

mx = linspace(min_c(1)-facXY*span(1), max_c(1)+facXY*span(1), Nxy);
my = linspace(min_c(2)-facXY*span(2), max_c(2)+facXY*span(2), Nxy);
mz = linspace(min_c(3)-facZ *span(3), max_c(3)+facZ *span(3), Nz);
[x,y,z] = meshgrid(mx,my,mz);
Hx = zeros(size(x)); Hy = Hx; Hz = Hx;

for i = 1:size(data,1)
    r0 = data(i,1:3); r1 = data(i,4:6); I = data(i,7);
    L = r1 - r0; Lmag = norm(L); if Lmag==0, continue; end
    Nseg = 20; t = linspace(0,1,Nseg); dl = L/Nseg;
    for j = 1:Nseg
        r_line = r0 + t(j)*L;
        Rx = x - r_line(1); Ry = y - r_line(2); Rz = z - r_line(3);
        Rmag = sqrt(Rx.^2 + Ry.^2 + Rz.^2); Rmag(Rmag==0)=eps;
        coef = I/(4*pi)./Rmag.^3;
        Hx = Hx + coef .* (dl(2)*Rz - dl(3)*Ry);
        Hy = Hy + coef .* (dl(3)*Rx - dl(1)*Rz);
        Hz = Hz + coef .* (dl(1)*Ry - dl(2)*Rx);
    end
    plot3(ax,[r0(1) r1(1)],[r0(2) r1(2)],[r0(3) r1(3)],'r','LineWidth',1.2);
end

if strcmpi(modo,'unitario')
    mag = sqrt(Hx.^2 + Hy.^2 + Hz.^2); mag(mag==0)=1;
    Hx = Hx./mag; Hy = Hy./mag; Hz = Hz./mag;
end
quiver3(ax,x,y,z,Hx,Hy,Hz,'Color','b','AutoScale','on','AutoScaleFactor',2);
axis(ax,'tight'); xlabel(ax,'x'); ylabel(ax,'y'); zlabel(ax,'z');
view(ax,3); grid(ax,'on');
title(ax,'Campo H para líneas finitas');
end
