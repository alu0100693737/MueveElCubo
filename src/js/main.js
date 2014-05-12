var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera(45, 1, 0.1, 1000);
var renderer = new THREE.WebGLRenderer();
var pointLight = new THREE.PointLight(0xFFFFFF);
var cubeLength = 10, cubeWidth = 20, cubeHeight = 10, segments = 10;
var boxGeometry = new THREE.BoxGeometry(cubeWidth, cubeHeight
	, cubeLength, segments, segments, segments);
var cubeMaterial = new THREE.MeshLambertMaterial({color: 0xCC0000});
var cube = new THREE.Mesh(boxGeometry, cubeMaterial);
var left = true;

function init() {
	renderer.setSize($("#context").width(), $("#context").height());

	$("#context").append(renderer.domElement);

	camera.lookAt(new THREE.Vector3(0, 0, -10));

	scene.add(pointLight);
    pointLight.position.x = 0;
    pointLight.position.y = 0;
    pointLight.position.z = 0;

    scene.add(cube);
    cube.position.x = 100;
    cube.position.y = -50;
    cube.position.z = -300;    

    render();
}

function render() {
   if(left == true) {
            cube.position.x += 1;
            cube.rotation.y += 0.01;
		    cube.rotation.x += 0.01;
		    cube.rotation.z += 0.01;
            if(cube.position.x >= 100) {
                    left = false;
            }
    } else {
		    cube.rotation.y -= 0.01;
		    cube.rotation.x -= 0.01;
		    cube.rotation.z -= 0.01;
            cube.position.x -= 1;
            if(cube.position.x <= -100) {
                    left = true;
            }
    }

    requestAnimationFrame(render);
    renderer.render(scene, camera);
}

window.onload = init