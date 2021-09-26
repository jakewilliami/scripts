module Pixels

include("coords.jl")
include("bounding_box.jl") # BoundingBox uses Coordinate
include("block_space.jl") # BlockSpace uses BoundingBox and Coordinate
include("point_grid.jl") # PointGrid uses BlockSpace and Coordinate

# block1 = Coordinate(1, 5, 7)
# block2 = Coordinate(5, 2, 4)
# space = BlockSpace([block1, block2])

# TODO:
# - Function to get the coordinates of the bounding box? I.e., each point.
# - PointGrid array in which Coordinates exist.  Should I use CartesianCoordinates instead?  Do their elements need to be any number, or integers?


end # end module
