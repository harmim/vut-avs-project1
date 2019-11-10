/*
 * Architektury výpočetních systémů (AVS 2019)
 * Projekt č. 1 (ANN)
 * Login: xharmi00
 */


#include <cmath>

#include "neuron.h"


float evalNeuron(
	size_t inputSize,
	size_t neuronCount,
	const float *input,
	const float *weights,
	float bias,
	size_t neuronId
)
{
	float x = bias;

	for (size_t i = 0; i < inputSize; i++)
	{
		x +=
			input[neuronCount * neuronId + i] *
			weights[neuronCount * i + neuronId];
	}

	return fmaxf(0f, x);
}
