

#ifndef WAV_H
#define WAV_H

#include <stdio.h>

class WavWriter {
public:
	WavWriter(const char *filename, int sampleRate, int bitsPerSample, int channels);
	~WavWriter();

	void writeData(const unsigned char* data, int length);

private:
	void writeString(const char *str);
	void writeInt32(int value);
	void writeInt16(int value);

	void writeHeader(int length);

	FILE *wav;
	int dataLength;

	int sampleRate;
	int bitsPerSample;
	int channels;
};

#endif

