//
//  ed25519_pub.h
//  Pods
//
//  Created by Stone on 2018/9/3.
//

#ifndef ed25519_pub_h
#define ed25519_pub_h

#include <stdlib.h>

#if defined(__cplusplus)
extern "C" {
#endif

    typedef unsigned char ed25519_signature[64];
    typedef unsigned char ed25519_public_key[32];
    typedef unsigned char ed25519_secret_key[32];

    typedef unsigned char curved25519_key[32];

    void ed25519_publickey(const ed25519_secret_key sk, ed25519_public_key pk);
    int ed25519_sign_open(const unsigned char *m, size_t mlen, const ed25519_public_key pk, const ed25519_signature RS);
    void ed25519_sign(const unsigned char *m, size_t mlen, const ed25519_secret_key sk, const ed25519_public_key pk, ed25519_signature RS);

    int ed25519_sign_open_batch(const unsigned char **m, size_t *mlen, const unsigned char **pk, const unsigned char **RS, size_t num, int *valid);

    void ed25519_randombytes_unsafe(void *out, size_t count);

#if defined(__cplusplus)
}
#endif


#endif /* ed25519_pub_h */
