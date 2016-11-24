#include <iostream>
#include <cstring>
#include <ctime>
#include <openssl/sha.h>
#include <openssl/bn.h>
#include <openssl/rand.h>

/***
* if the first plen bits of the hash result is zero
* res-hash result
* rlen-hash result length
* plen-puzzle length of bits
* return true if the first plen bits is zero, else return false
***/
bool checkZero(unsigned char *res, int rlen, int plen)
{
	int flag = ((plen % 8) == 0) ? 1 : 0;
	int plen_in_bytes = plen / 8;
	if (rlen <= (plen_in_bytes + flag))
	{
		return false;
	}
	if (plen <= 8)
	{
		return ((res[0] >> (8 - plen)) == 0) ? true : false;
	}
	else
	{
		for (int i = 0; i < plen_in_bytes; i++)
		{
			if (res[i] != 0)
			{
				return false;
			}
		}
		if (flag == 0)
		{
			return ((res[plen_in_bytes] >> (8 - plen % 8)) == 0) ? true : false;
		}
		return true;
	}
}
/***
* increment solution character
* solution-puzzle solution pointer
* slen-solution length of bytes
* return true if solution have incremented to maximum (can't be increment), else return false
***/
bool incSolution (unsigned char *solution, int slen)
{
	int idx = slen - 1;
	while ((solution[idx] == 255) && (idx != 0))
	{
		solution[idx]++;
		idx--;
	}
	if ((idx == 0) && (solution[idx] == 255))
	{
		return false;
	}
	else
	{
		solution[idx]++;
		return true;
	}
	
}
/***
* solve puzzle function
* msg-message pointer
* mlen-message length of bytes
* solution-puzzle solution pointer
* slen-solution length of bytes
* plen-puzzle length of bits
* return true if puzzle has a solution, else return false
***/
bool solvePuzzle(unsigned char *msg, int mlen, unsigned char *solution, int slen, int plen)
{
	SHA256_CTX shactx, shactx_bak;
	unsigned char hash_res[SHA224_DIGEST_LENGTH];
	memset(solution, 0, slen);

	SHA224_Init(&shactx);
	SHA224_Update(&shactx, msg, mlen);
	memcpy(&shactx_bak, &shactx, sizeof(SHA_CTX));
	SHA224_Update(&shactx, solution, slen);
	SHA224_Final(hash_res, &shactx);
	if (checkZero(hash_res, SHA224_DIGEST_LENGTH, plen))
	{
		return true;
	}
	while (incSolution(solution, slen))
	{
		memcpy(&shactx, &shactx_bak, sizeof(SHA_CTX));
		SHA224_Update(&shactx, solution, slen);
		SHA224_Final(hash_res, &shactx);
		if (checkZero(hash_res, SHA224_DIGEST_LENGTH, plen))
		{
			return true;
		}
	}
	return false;
}

void usage()
{
	printf("puzzle [loop] [message_len] [solution_len] [puzzle_len]\n");
}

void randomMsg(unsigned char *msg, unsigned int mlen)
{
	for (int i = 0; i < mlen; i++)
	{
		msg[i] = rand() % 256;
	}
}

int main(int argc, char **argv)
{
	if (argc < 5)
	{
		usage();
		return 1;
	}
	unsigned int loop = atoi(argv[1]);
	unsigned int mlen = atoi(argv[2]);
	unsigned int slen = atoi(argv[3]);
	unsigned int plen = atoi(argv[4]);
	unsigned char message[mlen];
	unsigned char solution[slen];

	int solved = 0;
	double solve_t = 0.0;
	clock_t start, end;

	srand(time(NULL));
	for (int i = 0; i < loop; i++)
	{
		randomMsg(message, mlen);
		start = clock();
		if (solvePuzzle(message, mlen, solution, slen, plen))
		{
			solved++;
			end = clock();
			solve_t += (end - start);
			//printf("Solved the puzzle!\n");
		}
	}
//	printf("Message len: %d bytes\n", mlen);
//	printf("Solution len: %d bytes\n", slen);
//	printf("Puzzle len: %d bits\n", plen);
//	printf("Loop times: %d\n", loop);
//	printf("Solved: %d\n", solved);
//	printf("Average solve time: %f us\n", solve_t / (double)(solved));
	printf("%f us\n", solve_t / (double)(solved));
	fflush(stdout);
	return 0;
}

