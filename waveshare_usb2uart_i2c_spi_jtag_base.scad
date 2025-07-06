include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <../OpenSCAD_Lib/torus.scad>

layerThickness = 0.2;
perimeterWidth = 0.4;

m3ClearanceDia = 3.5;
// m3HeadClearanceDia = 6;
// m3SocketHeadZ = 3;
// m3SquareNutDia = 7.9; // $fn=4
m3HexNutDia = 6.55; // $fn=6
m3NutZ = 2.4; // both square and hex

moduleBaseX = 88.5;
moduleBaseY = 48;
moduleBaseZ = 2.4;
moduleBaseCornerDia = 3.5;

moduleBodyY = 72.4;

moduleUartDupontConnCtrZ = 15.3;
moduleUartDupontConn1CtrX = 17.2;
moduleUartDupontConn2Ctrx = 32.4;
moduleUartDupontConnectorsCtrX = (moduleUartDupontConn1CtrX + moduleUartDupontConn2Ctrx)/2;

uartCableDia = 5;

echo(str("moduleUartDupontConnectorsCtrX = ", moduleUartDupontConnectorsCtrX));

mountingHoleCtrsX = 78.8; //79.1; //72.2 + 3.6;
mountingHoleCtrsY = 36.6 - 10;
mountingHoleDia = m3ClearanceDia;
mountingNutRecessDia = m3HexNutDia;
mouuntingNutRecessZ = m3NutZ + 0.5; // 0.3 of the screw past the bolt.
mountingBoltLength = 8;

echo(str("mountingHoleCtrsX = ", mountingHoleCtrsX));

// mountingBoltHeadToNutLength = mountingBoltLength - mouuntingNutRecessZ;

baseConnectorSideY = 37;
baseUsbSideY = 10;

baseX = moduleBaseX + 2*4;
baseY = moduleBaseY + baseConnectorSideY + baseUsbSideY;
baseZ = mountingBoltLength - moduleBaseZ + 0.7; // mountingBoltLength - mountingNutRecessTotalZ - moduleBaseZ;
baseCornerDia = 20;
baseCZ = 2;

echo(str("baseX = ", baseX));
echo(str("baseZ = ", baseZ));

mountingHolesOffsetY = moduleBaseY/2 - baseY/2 + baseConnectorSideY;

// 0.5mm extra in case the bolt is a little long
mountingNutRecessTotalZ = mouuntingNutRecessZ + 0.5;

uartStrainReliefDia = 20;
uartStrainReliefZ = baseZ + moduleUartDupontConnCtrZ;
uartStrainReliefCZ = 2;

uartStrainReliefCtrX = moduleBodyY/2 - 1; // + moduleUartDupontConnectorsCtrX;
uartStrainReliefCtrY = -baseY/2 + 19; //uartStrainReliefDia/2 + baseCZ;

module itemModule()
{
	difference()
    {
        union()
        {
            // Base:
            hull() 
                doubleX() doubleY() 
                    translate([baseX/2-baseCornerDia/2, baseY/2-baseCornerDia/2, 0])
                        simpleChamferedCylinder(d=baseCornerDia, h=baseZ, cz=baseCZ);

            // UART cable strain relief:
            translate([uartStrainReliefCtrX, uartStrainReliefCtrY, 0]) rotate([0,0,90])
            {
                difference() 
                {
                    zipTieDia = 4;
                    zipTieCZ = 1;
                    ctrsX = uartCableDia/2 + zipTieDia/2 + zipTieCZ + 0 + 2*perimeterWidth; // + uartStrainReliefCZ + 2;

                    // Body:
                    hull() doubleX() 
                        translate([ctrsX, 0, 0]) 
                            simpleChamferedCylinder(d=uartStrainReliefDia, h=uartStrainReliefZ, cz=uartStrainReliefCZ);

                    // Cable cutout:
                    translate([0,0,uartStrainReliefZ]) rotate([-90,0,0]) 
                    {
                        // Cable slot:
                        tcy([0,-0.4,-20], d=uartCableDia, h=40);
                        //Longitudinal chamfer:
                        doubleX() tcy([1.8, -1.2, -20], d=uartCableDia, h=40, $fn=4);
                        // End chamfers:
                        doubleZ() translate([0,0,uartStrainReliefDia/2-uartCableDia/2-uartStrainReliefCZ]) cylinder(d2=10, d1=0, h=5);
                    }

                    // Zip-Tie:
                    translate([0,0,uartStrainReliefZ])
                    {
                        doubleX() rotate([90,0,0]) torus2a(radius=zipTieDia/2, translation=ctrsX);

                        doubleX() translate([ctrsX, 0, -zipTieDia/2-zipTieCZ]) cylinder(d2=10, d1=0, h=5);
                    }

                    // Chamfer on cable cutout:

                }
            }
        }
        
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

module uartStrainReliefXform()
{
     
            children();
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
    // tcu([mountingHoleCtrsX/2+d, -200, -200], 400);
    // tcu([-200, uartStrainReliefCtrY-400, -200], 400);
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
