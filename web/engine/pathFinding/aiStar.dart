import 'dart:core';

import '../rendering/rayCaster/worldMap.dart';

class PathNode {
  int x;
  int y;
  late int idx;
  late int parent;
  late int g;
  late int h;
  late int f;

  PathNode(this.x, this.y);
}

class AStar {
  Map<int, PathNode> _closedSet = {};
  Map<int, PathNode> _openSet = {};
  List<PathNode> path = [];
  PathNode _currentNode = PathNode(0, 0);

  int _startX;
  int _startY;
  int _endX;
  int _endY;
  WorldMap _worldMap = WorldMap.instance;

  AStar(this._startX, this._startY, this._endX, this._endY) {
    int idx = translateCoordinatesToIdx(_startX, _startY);

    PathNode n = PathNode(_startX, _startY);
    n.idx = idx;
    n.parent = 0;
    n.g = 0;
    n.h = (getManhattanDistance(n.x, n.y));
    n.f = (n.g + n.h);

    _openSet[idx] = n;
  }

  int translateCoordinatesToIdx(int x, int y) {
    return x + (y * _worldMap.worldDefinition.width);
  }

  int getManhattanDistance(int x, int y) {
    return (((x - _endX).abs() + (y - _endY).abs()) * 10);
  }

  bool isOnClosedList(int idx) {
    for (var entry in _closedSet.entries) {
      var pathNode = entry.value;
      if (pathNode.idx == idx) {
        return true;
      }
    }
    return false;
  }

  bool isOnOpenedList(int idx) {
    for (var entry in _openSet.entries) {
      var pathNode = entry.value;
      if (pathNode.idx == idx) {
        return true;
      }
    }
    return false;
  }

  void addToOpenedList(PathNode pathNode) {
    _openSet[pathNode.idx] = pathNode;
  }

  void addToClosedList(PathNode pathNode) {
    _closedSet[pathNode.idx] = pathNode;
  }

  PathNode findLowestCost() {
    int f = 99999;
    int lowestCostIdx = 0;

    for (var entry in _openSet.entries) {
      PathNode pathNode = entry.value;

      if (pathNode.f <= f) {
        f = pathNode.f;
        lowestCostIdx = pathNode.idx;
      }
    }

    // Retrieve and remove the node with the lowest cost
    PathNode lowestNode = _openSet[lowestCostIdx]!;
    _openSet.remove(lowestCostIdx);
    return lowestNode;
  }

  int calculateGValue(int x, int y) {
    // Checking behind me
    if (x == (_currentNode.x - 1) && y == _currentNode.y) {
      bool wall = isWall(_currentNode.x - 1, _currentNode.y);
      return getTileWeight(wall);
      // Checking in front of me
    } else if (x == (_currentNode.x + 1) && y == _currentNode.y) {
      bool wall = isWall(_currentNode.x + 1, _currentNode.y);
      return getTileWeight(wall);
      // Checking above me
    } else if (x == (_currentNode.x) && y == _currentNode.y + 1) {
      bool wall = isWall(_currentNode.x, _currentNode.y + 1);
      return getTileWeight(wall);
      // Checking below me
    } else if (x == (_currentNode.x) && y == _currentNode.y - 1) {
      bool wall = isWall(_currentNode.x, _currentNode.y - 1);
      return getTileWeight(wall);
      // Checking diagonal
    } else {
      return 1400;
    }
  }

  int getTileWeight(bool wall) {
    if (!wall) {
      return 10;
    } else {
      return 100000;
    }
  }

  void buildNodeList() {
    for (int y = (_currentNode.y + 1); y >= (_currentNode.y - 1); y--) {
      for (int x = (_currentNode.x - 1); x < (_currentNode.x + 2); x++) {
        if (x == _currentNode.x && y == _currentNode.y) {
          continue;
        } else {
          if (y >= 0 &&
              x >= 0 &&
              x < (_worldMap.worldDefinition.width - 1) &&
              y < (_worldMap.worldDefinition.height - 1)) {
            int cost = _currentNode.g + calculateGValue(x, y);
            int idx = translateCoordinatesToIdx(x, y);

            if (isOnOpenedList(idx) && cost < _openSet[idx]!.g) {
              _openSet[idx]!.g = cost;
              _openSet[idx]!.f = _openSet[idx]!.g + _openSet[idx]!.h;
              _openSet[idx]!.parent = _currentNode.idx;
            } else if (isOnClosedList(idx)) {
              continue;
            } else if (!isOnOpenedList(idx)) {
              PathNode n = PathNode(0, 0);
              n.g = cost;
              n.x = x;
              n.y = y;
              n.h = (getManhattanDistance(x, y));
              n.idx = idx;
              n.parent = _currentNode.idx;
              n.f = n.g + n.h;
              addToOpenedList(n);
            }
          }
        }
      }
    }
  }

  void buildRoute() {
    int startIdx = translateCoordinatesToIdx(_startX, _startY);
    int idx = translateCoordinatesToIdx(_endX, _endY);

    while (idx != startIdx) {
      path.add(_closedSet[idx]!);
      idx = _closedSet[idx]!.parent;
    }
  }

  bool isPathFound() {
    bool pathFound = false;

    while (_openSet.isNotEmpty) {
      _currentNode = findLowestCost();
      addToClosedList(_currentNode);

      if (_currentNode.idx == translateCoordinatesToIdx(_endX, _endY)) {
        buildRoute();

        pathFound = true;
        break;
      } else {
        buildNodeList();
      }
    }

    return pathFound;
  }

  bool isWall(int x, int y) {
    return _worldMap.getEntityAtPosition(x, y).hasComponent("wall");
  }
}