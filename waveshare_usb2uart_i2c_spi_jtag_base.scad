include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

layerThickness = 0.2;

m3ClearanceDia = 3.5;
// m3HeadClearanceDia = 6;
// m3SocketHeadZ = 3;
// m3SquareNutDia = 7.9; // $fn=4
m3HexNutDia = 6.4; // $fn=6
m3NutZ = 2.4; // both square and hex

moduleBaseX = 86;
moduleBaseY = 48;
moduleBaseZ = 2.4;
moduleBaseCornerDia = 3.5;
moduleDupontConnCtrZ = 15.3;
moduleDupontConn1CtrX = 17.2;
moduleDupontConn2Ctrx = 32.4;

mountingHoleCtrsX = 72.2 + 3.6;
mountingHoleCtrsY = 36.6 - 10;
mountingHoleDia = m3ClearanceDia;
mountingNutRecessDia = m3HexNutDia;
mouuntingNutRecessZ = m3NutZ + 0.5; // 0.3 of the screw past the bolt.
mountingBoltLength = 8;

// mountingBoltHeadToNutLength = mountingBoltLength - mouuntingNutRecessZ;

baseConnectorSideY = 25;
baseUsbSideY = 10;

baseX = moduleBaseX + 2*4;
baseY = moduleBaseY + baseConnectorSideY + baseUsbSideY;
baseZ = mountingBoltLength - moduleBaseZ + 0.7; // mountingBoltLength - mountingNutRecessTotalZ - moduleBaseZ;
baseCornerDia = 20;
baseCZ = 2;

echo(str("baseZ = ", baseZ));

mountingHolesOffsetY = moduleBaseY/2 - baseY/2 + baseConnectorSideY;

// 0.5mm extra in case the bolt is a little long
mountingNutRecessTotalZ = mouuntingNutRecessZ + 0.5;

module itemModule()
{
	difference()
    {
        // Base:
        hull() 
            doubleX() doubleY() 
                translate([baseX/2-baseCornerDia/2, baseY/2-baseCornerDia/2, 0])
                    simpleChamferedCylinder(d=baseCornerDia, h=baseZ, cz=baseCZ);
        
        // Mounting holes:
        mountingHolesXform()
            {
                // Hole:
                tcy([0,0,-1], d=mountingHoleDia, h=20);
                // Nut recess:
                rotate([0,0,30]) tcy([0,0,-10+mountingNutRecessTotalZ], d=mountingNutRecessDia, h=10, $fn=6);
            }
    }
    // Sacrificial layer:
    mountingHolesXform() tcy([0,0,mountingNutRecessTotalZ], d=8, h=layerThickness);
}

module mountingHolesXform()
{
    translate([0, mountingHolesOffsetY, 0]) doubleX() doubleY() 
        translate([mountingHoleCtrsX/2, mountingHoleCtrsY/2, 0])
            children();
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
    tcu([mountingHoleCtrsX/2+d, -200, -200], 400);
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
