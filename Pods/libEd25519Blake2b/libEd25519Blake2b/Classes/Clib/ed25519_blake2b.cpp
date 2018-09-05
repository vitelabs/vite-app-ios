//
//  ed25519_blake2b.cpp
//  libEd25519Blake2b
//
//  Created by Stone on 2018/8/31.
//

#include "ed25519_blake2b.hpp"

#include "ed25519.h"
#include "blake2.h"

#include <cstring>
#include <random>

extern "C" {


#include "ed25519-hash-custom.h"


void ed25519_randombytes_unsafe (void * out, size_t outlen)
{
    std::default_random_engine generator((uint_fast32_t)time(0));
    std::uniform_int_distribution<uint8_t> distribution(0, 255);

    uint8_t *a = new uint8_t[outlen];

    for (int i = 0; i < outlen; i++) {
        a[i] = distribution(generator);
    }

    memcpy(out, a, outlen);
    delete []a;
}
    
void ed25519_hash_init (ed25519_hash_context * ctx)
{
    ctx->blake2 = new blake2b_state;
    blake2b_init (reinterpret_cast<blake2b_state *> (ctx->blake2), 64);
}

void ed25519_hash_update (ed25519_hash_context * ctx, uint8_t const * in, size_t inlen)
{
    blake2b_update (reinterpret_cast<blake2b_state *> (ctx->blake2), in, inlen);
}

void ed25519_hash_final (ed25519_hash_context * ctx, uint8_t * out)
{
    blake2b_final (reinterpret_cast<blake2b_state *> (ctx->blake2), out, 64);
    delete reinterpret_cast<blake2b_state *> (ctx->blake2);
}

void ed25519_hash (uint8_t * out, uint8_t const * in, size_t inlen)
{
    ed25519_hash_context ctx;
    ed25519_hash_init (&ctx);
    ed25519_hash_update (&ctx, in, inlen);
    ed25519_hash_final (&ctx, out);
}

}
