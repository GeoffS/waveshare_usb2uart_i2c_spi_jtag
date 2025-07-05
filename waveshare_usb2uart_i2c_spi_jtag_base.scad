include <../OpenSCAD_Lib/MakeInclude.scad>

baseConnectorSideY = 25;
baseUsbSideY = 10;

baseX = 86 + 2*4;
baseY = 48 + baseConnectorSideY + baseUsbSideY;
baseZ = 3;
baseCornerDia = 8;

module itemModule()
{
	difference()
    {
        hull() 
            doubleX() doubleY() 
                translate([baseX/2-baseCornerDia/2, baseY/2-baseCornerDia/2, 0]) 
                    cylinder(d=baseCornerDia, h=baseZ);
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
