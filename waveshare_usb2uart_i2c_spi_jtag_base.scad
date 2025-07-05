include <../OpenSCAD_Lib/MakeInclude.scad>

moduleBaseZ = 2.4;
moduleDubontConnCtrZ = 15.3;
moduleDubontConn1CtrX = 17.2;
moduleDubontConn2Ctrx = 32.4;

baseConnectorSideY = 25;
baseUsbSideY = 10;

baseX = 86 + 2*4;
baseY = 48 + baseConnectorSideY + baseUsbSideY;
baseZ = 3;
baseCornerDia = 8;

mountingHoleCtrsX = 72.2 + 3.6/2;
mountingHoleCtrsY = 36.6 - 10;
mountingHoleDia = 3.3;

module itemModule()
{
	difference()
    {
        hull() 
            doubleX() doubleY() 
                translate([baseX/2-baseCornerDia/2, baseY/2-baseCornerDia/2, 0]) 
                    cylinder(d=baseCornerDia, h=baseZ);
        
        // Mounting holes:
        doubleX() doubleY() 
            translate([mountingHoleCtrsX/2, mountingHoleCtrsY, -1]) 
                cylinder(d=mountingHoleDia, h=20);
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
