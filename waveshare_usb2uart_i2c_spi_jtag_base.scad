include <../OpenSCAD_Lib/MakeInclude.scad>

moduleBaseX = 86;
moduleBaseY = 48;
moduleBaseZ = 2.4;
moduleBaseCornerDia = 3.5;
moduleDupontConnCtrZ = 15.3;
moduleDupontConn1CtrX = 17.2;
moduleDupontConn2Ctrx = 32.4;

baseConnectorSideY = 25;
baseUsbSideY = 10;

baseX = moduleBaseX + 2*4;
baseY = moduleBaseY + baseConnectorSideY + baseUsbSideY;
baseZ = 3;
baseCornerDia = 8;

mountingHoleCtrsX = 72.2 + 3.6/2;
mountingHoleCtrsY = 36.6 - 10;
mountingHoleDia = 3.3;

mountingHolesOffsetY = moduleBaseY/2 - baseY/2 + baseConnectorSideY;

module itemModule()
{
	difference()
    {
        // Base:
        hull() 
            doubleX() doubleY() 
                translate([baseX/2-baseCornerDia/2, baseY/2-baseCornerDia/2, 0]) 
                    cylinder(d=baseCornerDia, h=baseZ);
        
        // Mounting holes:
        translate([0, mountingHolesOffsetY, 0]) doubleX() doubleY() 
            translate([mountingHoleCtrsX/2, mountingHoleCtrsY/2, -1]) 
                cylinder(d=mountingHoleDia, h=20);
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() translate([0,0,0.001]) itemModule();
    displayGhost() moduleGhost();
}
else
{
	itemModule();
}

module moduleGhost()
{
    translate([0, -baseY/2+baseConnectorSideY, baseZ])
    {
        translate([0, moduleBaseY/2, 0]) hull() 
            doubleX() doubleY() 
                translate([moduleBaseX/2-moduleBaseCornerDia/2, moduleBaseY/2-moduleBaseCornerDia/2, 0]) 
                    cylinder(d=moduleBaseCornerDia, h=moduleBaseZ);
        x = 72.2;
        y = 48;
        z = 27.6;
        tcu([-x/2, 0, 0], [x, y, z]);
    }
}
