//
// Coordinate Point Class
class CoordinatePoint {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
//
// Method of CoordinatePoint Class that find Hypotenuse distance between current and selected Coordinate Point
extension CoordinatePoint {
    func findDistance(with point: CoordinatePoint) -> Double {
        var cathetus1 = abs(point.y - self.y)
        var cathetus2 = abs(point.x - self.x)
        var distance = (Double((cathetus1 * cathetus1) + (cathetus2 * cathetus2))).squareRoot()
        return distance
    }
}
//
// Method that find Closest LineSegment to Coordinate Point and return it with next point, Bool value that indicate that
//should cut from the end of Line Segment
extension CoordinatePoint {
    func findClosestLineSegment(to lineSegmentArray: [LineSegment]) -> (nextPoint: CoordinatePoint, closestlineSegment: LineSegment, isLineSegmentShouldBeReversed: Bool) {
        var nextPoint: CoordinatePoint!
        var minDistance = Double.infinity
        var closestLineSegment: LineSegment!
        var isLineSegmentShouldBeReversed: Bool = false
        
        for lineSegment in lineSegmentArray {
            var distance1 = self.findDistance(with: lineSegment.coordinate1)
            if distance1 < minDistance {
                minDistance = distance1
                nextPoint = lineSegment.coordinate2
                closestLineSegment = lineSegment
                isLineSegmentShouldBeReversed = false
            }
            var distance2 = self.findDistance(with: lineSegment.coordinate2)
            if distance2 < minDistance {
                minDistance = distance2
                nextPoint = lineSegment.coordinate1
                closestLineSegment = lineSegment
                isLineSegmentShouldBeReversed = true
            }
        }
        return (nextPoint, closestLineSegment, isLineSegmentShouldBeReversed)
    }
}
//
// Line Segment Class
class LineSegment {
    var coordinate1: CoordinatePoint
    var coordinate2: CoordinatePoint
    
    init(coordinate1: CoordinatePoint, coordinate2: CoordinatePoint) {
        self.coordinate1 = coordinate1
        self.coordinate2 = coordinate2
    }
    //Method that create new Line Segment
    static func create(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) -> LineSegment {
        return LineSegment(coordinate1: CoordinatePoint(x: x1, y: y1), coordinate2: CoordinatePoint(x: x2, y: y2))
    }
}
//
// Method of LineSegment Class that check if current Line Segmend overlap Other
extension LineSegment {
    func isOverlap(lineSegment: LineSegment) -> Bool {
        let isAllXEqual: Bool = Set([self.coordinate1.x, self.coordinate2.x, lineSegment.coordinate1.x, lineSegment.coordinate2.x]).count == 1
        let isIncludeByY = self.coordinate1.y <= lineSegment.coordinate1.y && self.coordinate2.y >= lineSegment.coordinate2.y

        let isAllYEqual: Bool = Set([self.coordinate1.y, self.coordinate2.y, lineSegment.coordinate1.y, lineSegment.coordinate2.y]).count == 1
        let isIncludeByX = self.coordinate1.x <= lineSegment.coordinate1.x && self.coordinate2.x >= lineSegment.coordinate2.x

        return (isAllXEqual && isIncludeByY) || (isAllYEqual && isIncludeByX)
    }
}
//
// Method of LineSegment Class that print in console Line Segment Coordinates
extension LineSegment {
    func printLineSegmentCoordinate() {
        print("\(self.coordinate1.x), \(self.coordinate1.y), \(self.coordinate2.x), \(self.coordinate2.y)")
    }
}
//
// Figure Class
class Figure {
    var coordinatePoints: [CoordinatePoint]
    var startPoint: CoordinatePoint
    
    init(coordinatePoints: [CoordinatePoint], startPoint: CoordinatePoint) {
        self.coordinatePoints = coordinatePoints
        self.startPoint = startPoint
    }
    //Method that create new Figure
    static func create(_ xA: Int, _ yA: Int, _ xB: Int, _ yB: Int, _ xC: Int, _ yC: Int, _ xD: Int, _ yD: Int, _ startPointX: Int, _ startPointY: Int) -> Figure {
        return Figure(coordinatePoints: [CoordinatePoint(x: xA, y: yA), CoordinatePoint(x: xB, y: yB), CoordinatePoint(x: xC, y: yC), CoordinatePoint(x: xD, y: yD)], startPoint: CoordinatePoint(x: startPointX, y: startPointY))
    }
}
//
// Method of Figure Class that convert Figure into array of Line Segments
extension Figure {
    func transformFigureToLineSegments() -> [LineSegment] {
        var lineSegmentsArray: [LineSegment] = []
        
        let lastElementIndex = coordinatePoints.count - 1
        for i in 0...(lastElementIndex - 1) {
            let coordinate1 = CoordinatePoint(x: coordinatePoints[i].x + startPoint.x, y: coordinatePoints[i].y + startPoint.y)
            let coordinate2 = CoordinatePoint(x: coordinatePoints[i + 1].x + startPoint.x, y: coordinatePoints[i + 1].y + startPoint.y)
            let newLineSegment = LineSegment(coordinate1: coordinate1, coordinate2: coordinate2)
            lineSegmentsArray.append(newLineSegment)
        }

        let lastLineSegmentCoordinate1 = CoordinatePoint(x: coordinatePoints.last!.x + startPoint.x, y: coordinatePoints.last!.y + startPoint.y)
        let lastLineSegmentCoordinate2 = CoordinatePoint(x: coordinatePoints.first!.x + startPoint.x, y: coordinatePoints.first!.y + startPoint.y)
        let lastLineSegment = LineSegment(coordinate1: lastLineSegmentCoordinate1, coordinate2: lastLineSegmentCoordinate2)
        lineSegmentsArray.append(lastLineSegment)
        
        return lineSegmentsArray
    }
}
//
// Method that transform Array of Figures into Array of Line Segments
func transformFiguresArrayToLineSegmentsArray(figuresArray: [Figure]) -> [LineSegment] {
    var newLineSegmentsArray: [LineSegment] = []
    for figure in figuresArray {
        newLineSegmentsArray += figure.transformFigureToLineSegments()
    }
    return newLineSegmentsArray
}
//
// Method that create new Line Segment Array without overlapping
func findAndExcludeOverlappedLineSegments(in lineSegmentsArray: [LineSegment]) -> [LineSegment] {
    var newLineSegmentArray: [LineSegment] = lineSegmentsArray
    for i in 0 ..< (newLineSegmentArray.count - 1) {
        var j = i + 1
        while j < newLineSegmentArray.count {
            if newLineSegmentArray[i].isOverlap(lineSegment: newLineSegmentArray[j]) {
                newLineSegmentArray = newLineSegmentArray.filter { $0 !== newLineSegmentArray[j] }
                j -= 1
            }
            j += 1
        }
    }
    return newLineSegmentArray
}
//
// Method that Create Seqence of Line Segments to cut in optimal sequence
func getLineSegmentsSeqence(from array: [LineSegment]) -> [LineSegment] {
    var remainingLineSegments = array
    var resultArray: [LineSegment] = []
    var point: CoordinatePoint? = CoordinatePoint(x: 0, y: 0)

    while point != nil {
        let result = point!.findClosestLineSegment(to: remainingLineSegments)
        let newElement = result.isLineSegmentShouldBeReversed ? LineSegment(coordinate1: result.closestlineSegment.coordinate2, coordinate2: result.closestlineSegment.coordinate1) : result.closestlineSegment
        resultArray.append(newElement)

        remainingLineSegments = remainingLineSegments.filter { $0 !== result.closestlineSegment }

        point = remainingLineSegments.count > 0 ? result.nextPoint : nil
    }

    return resultArray
}
//
// Method that take array of Figures, Line Segment List and return Optimal Line Segments List
func createOptimalLineSegmentsList(use figuresArray: [Figure], _ lineSegmentList: [LineSegment]) -> [LineSegment] {
    let figureArrayInLineSegmentArray: [LineSegment] = transformFiguresArrayToLineSegmentsArray(figuresArray: figuresArray)
    let allLineSegmentsArray = lineSegmentList + figureArrayInLineSegmentArray
    var allLineSegmentsArrayWithoutOverlapping = findAndExcludeOverlappedLineSegments(in: allLineSegmentsArray)
    var optimalLineSegmentsList = getLineSegmentsSeqence(from: allLineSegmentsArrayWithoutOverlapping)
    return optimalLineSegmentsList
}
//
// Line Segment List
let lineSegmentList = [
    LineSegment.create(15, 0, 15, 3210),
    LineSegment.create(0, 15, 6000, 15),
    LineSegment.create(1500, 0, 1500, 3210),
    LineSegment.create(15, 1015, 1500, 1015),
    LineSegment.create(15, 2015, 1500, 2015),
    LineSegment.create(15, 3015, 1500, 3015),
    LineSegment.create(2550, 0, 2550, 3210),
    LineSegment.create(1500, 1415, 2550, 1415),
    LineSegment.create(1500, 2815, 2550, 2815),
    LineSegment.create(3991, 0, 3991, 3210),
    LineSegment.create(2550, 515, 3991, 515),
    LineSegment.create(2550, 1015, 3991, 1015),
    LineSegment.create(2550, 1515, 3991, 1515),
    LineSegment.create(2550, 2015, 3991, 2015),
    LineSegment.create(2550, 2765, 3991, 2765),
    LineSegment.create(3250, 2015, 3250, 2765),
    LineSegment.create(4789, 0, 4789, 3210),
    LineSegment.create(3991, 1515, 4789, 1515),
    LineSegment.create(3991, 3015, 4789, 3015),
    LineSegment.create(5843, 0, 5843, 3210),
    LineSegment.create(4789, 1123, 5843, 1123),
    LineSegment.create(5316, 15, 5316, 1123),
]
//
// Array of Figures
let figuresArray = [
    Figure.create(0, 0, 1470, 0, 1200, 1000, 0, 1000, 15, 15),
    Figure.create(0, 0, 1470, 0, 1200, 1000, 0, 1000, 15, 1015),
    Figure.create(15, 0, 1485, 1000, 285, 1000, 285, 1000, 15, 2015),
    Figure.create(0, 0, 798, 0, 798, 1485, 0, 1000, 3991, 15),
    Figure.create(0, 0, 798, 0, 798, 1200, 0, 1485, 3991, 1515),
    Figure.create(15, 0, 685, 0, 600, 735, 150, 735, 2550, 2015)
]
//
// Implementation of Algoritm that take array of Figures, Line Segment List and return Optimal Line Segments List
let optimalLineSegmentsList = createOptimalLineSegmentsList(use: figuresArray, lineSegmentList)
//
// Print Optimal Line Segments List values in console
for lineSegment in optimalLineSegmentsList {
    lineSegment.printLineSegmentCoordinate()
}
