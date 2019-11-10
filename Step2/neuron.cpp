/*
 * Architektury výpočetních systémů (AVS 2019)
 * Projekt č. 1 (ANN)
 * Login: xharmi00
 */


#include <cmath>

#include "neuron.h"


float evalNeuron(
	size_t inputSize,
	const float *input,
	const float *weights,
	float bias
)
{
	float x = bias;

	for (size_t i = 0; i < inputSize; i++)
	{
		x += input[i] * weights[i];
	}

	return fmaxf(.0f, x);
}
