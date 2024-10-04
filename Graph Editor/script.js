const canvas = document.getElementById("graphCanvas");
const ctx = canvas.getContext("2d");
canvas.width = 800;
canvas.height = 600;

let nodes = [];
let connections = [];
let currentConnectionType = "unidirectional";
let nodeCounter = 0;
let draggingNode = null; // Node that is currently being dragged

canvas.addEventListener("click", addConnection);
canvas.addEventListener("mousedown", startDraggingNode);
canvas.addEventListener("mousemove", dragNode);
canvas.addEventListener("mouseup", stopDraggingNode);

class Node {
  constructor(x, y, name) {
    this.x = x;
    this.y = y;
    this.radius = 20;
    this.name = name || `Node ${nodeCounter}`;
  }

  draw() {
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    ctx.fillStyle = "lightblue";
    ctx.fill();
    ctx.stroke();
    ctx.closePath();

    // Draw node name
    ctx.fillStyle = "black";
    ctx.fillText(this.name, this.x - this.radius / 2, this.y + 5);
  }

  isPointInside(x, y) {
    return Math.hypot(this.x - x, this.y - y) < this.radius;
  }
}

class Connection {
  constructor(node1, node2, type) {
    this.node1 = node1;
    this.node2 = node2;
    this.type = type; // 'unidirectional' or 'bidirectional'
  }

  draw() {
    ctx.beginPath();
    ctx.moveTo(this.node1.x, this.node1.y);
    ctx.lineTo(this.node2.x, this.node2.y);

    // Different colors for uni and bidirectional connections
    ctx.strokeStyle = this.type === "unidirectional" ? "blue" : "green";
    ctx.stroke();
    ctx.closePath();

    if (this.type === "unidirectional") {
      drawArrow(ctx, this.node1, this.node2);
    } else {
      drawArrow(ctx, this.node1, this.node2);
      drawArrow(ctx, this.node2, this.node1);
    }
    ctx.strokeStyle = "black"; // Reset stroke style
  }
}

function drawArrow(ctx, node1, node2) {
  const headlen = 10;
  const angle = Math.atan2(node2.y - node1.y, node2.x - node1.x);
  ctx.beginPath();
  ctx.moveTo(node2.x, node2.y);
  ctx.lineTo(
    node2.x - headlen * Math.cos(angle - Math.PI / 6),
    node2.y - headlen * Math.sin(angle - Math.PI / 6)
  );
  ctx.moveTo(node2.x, node2.y);
  ctx.lineTo(
    node2.x - headlen * Math.cos(angle + Math.PI / 6),
    node2.y - headlen * Math.sin(angle + Math.PI / 6)
  );
  ctx.stroke();
}

function addNode() {
  const x = Math.random() * (canvas.width - 40) + 20;
  const y = Math.random() * (canvas.height - 40) + 20;
  const name = prompt("Enter node name:");
  nodeCounter++;
  const newNode = new Node(x, y, name || `Node ${nodeCounter}`);
  nodes.push(newNode);
  drawGraph();
}

function toggleConnectionType() {
  currentConnectionType =
    currentConnectionType === "unidirectional"
      ? "bidirectional"
      : "unidirectional";
}

function addConnection(event) {
  const x = event.offsetX;
  const y = event.offsetY;
  const selectedNode = nodes.find((node) => node.isPointInside(x, y));

  if (selectedNode) {
    if (!window.firstNode) {
      window.firstNode = selectedNode;
    } else {
      const newConnection = new Connection(
        window.firstNode,
        selectedNode,
        currentConnectionType
      );
      connections.push(newConnection);
      window.firstNode = null;
      drawGraph();
    }
  }
}

function drawGraph() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  connections.forEach((connection) => connection.draw());
  nodes.forEach((node) => node.draw());
}

// Node dragging functionality
function startDraggingNode(event) {
  const x = event.offsetX;
  const y = event.offsetY;

  // Check if the user clicked on a node
  draggingNode = nodes.find((node) => node.isPointInside(x, y));
}

function dragNode(event) {
  if (draggingNode) {
    draggingNode.x = event.offsetX;
    draggingNode.y = event.offsetY;
    drawGraph();
  }
}

function stopDraggingNode() {
  draggingNode = null;
}

function generateAdjacencyMatrix() {
  const matrix = Array(nodes.length)
    .fill(null)
    .map(() => Array(nodes.length).fill(0));

  connections.forEach((connection) => {
    const node1Index = nodes.indexOf(connection.node1);
    const node2Index = nodes.indexOf(connection.node2);

    matrix[node1Index][node2Index] = 1;
    if (connection.type === "bidirectional") {
      matrix[node2Index][node1Index] = 1;
    }
  });

  displayMatrix(matrix);
  copyToClipboard(matrix);
}

function displayMatrix(matrix) {
  const matrixContainer = document.getElementById("adjacencyMatrix");
  matrixContainer.innerHTML = `<h2>Adjacency Matrix</h2><pre>${matrix
    .map((row) => row.join(" "))
    .join("\n")}</pre>`;
}

function copyToClipboard(matrix) {
  const flatMatrix = matrix.flat().join("");
  navigator.clipboard
    .writeText(flatMatrix)
    .then(() => {
      alert("Matrix copied to clipboard!");
    })
    .catch((err) => {
      alert("Failed to copy matrix!");
    });
}

function pasteMatrix() {
  const matrixString = document.getElementById("matrixInput").value.trim();
  const matrixSize = Math.sqrt(matrixString.length);

  if (matrixSize % 1 !== 0 || matrixString.length === 0) {
    alert("Invalid matrix sequence!");
    return;
  }

  nodes = [];
  connections = [];

  for (let i = 0; i < matrixSize; i++) {
    addNode();
  }

  let counter = 0;
  for (let i = 0; i < matrixSize; i++) {
    for (let j = 0; j < matrixSize; j++) {
      if (matrixString[counter] === "1") {
        const type =
          matrixString[j * matrixSize + i] === "1"
            ? "bidirectional"
            : "unidirectional";
        const newConnection = new Connection(nodes[i], nodes[j], type);
        connections.push(newConnection);
      }
      counter++;
    }
  }

  drawGraph();
}

drawGraph();
