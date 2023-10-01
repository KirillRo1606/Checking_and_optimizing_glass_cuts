# Checking_and_optimizing_glass_cuts
See README.

Checking and optimizing glass cuts

There is a CNC machine for cutting sheets of glass. Rectangular sheets of glass are fed onto it, and the cutting tool of the machine (hereinafter referred to as the cutter) carries out the cutting process. The machine cutter has 2 modes of movement: “idling”, when it moves in a raised state; and the “working stroke”, when it moves and directly cuts the glass.
Programming the operation of the machine is carried out by specifying a list of segments along which the cutter moves. The list of segments includes the input set of segments itself and some sides of the shapes from the input set of shapes.
It is required to implement an algorithm with the functions:
- converting the sides of figures into segments with coordinates in SKL;
- search and exclusion from the list of segments that overlap other segments;
- optimization of the list of segments to reduce the “no-load” distance of the cutter.
The algorithm must take as input parameters: - A list of figures - given in “Input data”.
The figure is described by 4 points on the plane with coordinates (X, Y), forming a quadrilateral. The coordinates of the figure points are given in the figure coordinate system (SCF).
The position of the figure on the sheet is specified by the coordinates of the origin of the figure coordinate system (SCF) in the sheet coordinate system (SCS). The origin of the sheet coordinate system (SCS) coincides with the lower left corner of the sheet.

- The list of segments on the sheet plane is given in “Input data”.
The segments are specified by two points, the point is determined by the coordinates X, Y (SKL). Note: all coordinates are integer, all segments are rectilinear. Conditions:
The list of segments is transferred to the glass cutting machine. To successfully and economically perform a glass cutting operation, the following conditions must be met:
- the sides of the figures must be converted into segments and added to the general list of segments;
- the machine should not cut twice along the same line. That is, exclude from the list segments that completely overlap other segments;
- it is necessary to reduce the “idling” distance of the cutter. That is, the remaining segments must be arranged in the list in such a way that the beginning of the next segment is the closest point to the end of the current segment. To do this, you can change the position of segments in the list and swap the starting and ending points of a suitable segment.
Explanation
The cutter starts moving from the origin of the SKL coordinates (point (0,0) coincides with the lower left corner of the sheet) and moves in a straight line to the starting point of the first segment from the list in a raised state (“idling”). At this point, the cutter lowers and, moving to the end point of the segment, cuts through the glass. Next, the cutter rises and moves in a straight line to the starting point of the next segment, etc.
Result of the algorithm:
- A list of segments that meets the conditions and is specified by the coordinates X1, Y1, X2, Y2 in the SKL.

Input data

List of segments:
Each line is a separate segment, specified by the coordinates X1, Y1, X2, Y2 in the SKL:
15, 0, 15, 3210
0, 15, 6000, 15
1500, 0, 1500, 3210
15, 1015, 1500, 1015
15, 2015, 1500, 2015
15, 3015, 1500, 3015
2550, 0, 2550, 3210
1500, 1415, 2550, 1415
1500, 2815, 2550, 2815
3991, 0, 3991, 3210
2550, 515, 3991, 515
2550, 1015, 3991, 1015
2550, 1515, 3991, 1515
2550, 2015, 3991, 2015
2550, 2765, 3991, 2765
3250, 2015, 3250, 2765
4789, 0, 4789, 3210
3991, 1515, 4789, 1515
3991, 3015, 4789, 3015
5843, 0, 5843, 3210
4789, 1123, 5843, 1123
5316, 15, 5316, 1123

List of figures. 

Each figure is described by 4 points (X, Y) in the GFR

Figure 1:
4 points of the figure:
0, 0
1470, 0
1200, 1000
0, 1000
Position of the figure in the SKL:
15, 15

Figure 2:
4 points of the figure:
0, 0
1470, 0
1200, 1000
0, 1000
Position of the figure in the SKL:
15, 1015

Figure 3:
4 points of the figure:
15, 0
1485, 0
1485, 1000
285, 1000
Position of the figure in the SKL:
15, 2015

Figure 4:
4 points of the figure:
0, 0
798.0
798, 1485
0, 1000
Position of the figure in SKL: 3991, 15

Figure 5:
4 points of the figure:
0, 0
798.0
798, 1200
0.1485
Position of the figure in SKL: 3991, 1515

Figure 6:
4 points of the figure:
15, 0
685.0
600, 735
150, 735
Position of the figure in SKL: 2550, 2015

Example.

Input data:
List of segments:
500, 0, 500, 3210 0, 15, 6000, 15
2000, 0, 2000, 3210 500, 1515, 2000, 1515

Figure:
4 points of the figure:
0, 0
1500, 0
1500, 1000
0.1485
Position of the figure in SKL: 500, 15

Result of the algorithm:

0, 15, 6000, 15 
2000, 0, 2000, 3210 
500, 3210, 500, 0 
500, 1500, 2000, 1015 
2000, 1515, 500, 1515
