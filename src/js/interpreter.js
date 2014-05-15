var Interpreter = new function(input) {
	var instPointer = 0;
	var timer;
	var input = input;
	var interval;
	this.run = function() {
		interval = setInterval(readInst, 1000);
	};

	readInst = function() {
		//var currentInst = input[instPointer];
		instPointer++;
		switch(input[instPointer][0]) { // << FIXME: Este switch es un stub, hay que escribirlo bien
			case "stop":
			stopInst();
			break;
			case "move":
			vecInst(input[instPointer][1]);
			break;
			case "turn":
			case "pitch":
			case "yaw":
			floatInst(input[instPointer][0], input[instPointer][1]);
			break;
		}
		requestAnimationFrame(render);
		renderer.render(scene, camera);
	};


	floatInst = function(inst, operand) {
		switch(inst) {
			case "turn":
			cube.rotation.y += operand;
			break;
			case "pitch":
			cube.rotation.z += operand;
			break;
			case "yaw":
			cube.rotation.x += operand;
			break;
		}
	};

	vecInst = function(vect) { // << FIXME: hay que descomponer las 3 componentes del vector
		cube.position.x;
		cube.position.y;
		cube.position.z;
	};

	stopInst = function() {
		clearInterval(interval);
	}
}

Interpreter.run();