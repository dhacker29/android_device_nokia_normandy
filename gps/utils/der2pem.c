/*
Copyright (c) 2013, The Linux Foundation. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "der2pem.h"

#include <openssl/x509.h>
#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <openssl/pem.h>

/* non-public declarations, though available as symbols */
int der2pem_load(const char *fname, X509 **cer);
int der2pem_save(const char *fname, X509 *cer);

/**
 * @brief Loads X509 certificate from file in DER format.
 *
 * This method reads X509 certificate from a local file.
 * @param[in]  fname Input file name
 * @param[out] cer   Pointer to X509
 * @retval 0         on success
 * @retval -1        on error
 */
int der2pem_load(const char *fname, X509 **cer)
{
  BIO *in;

  if (!fname || !cer)
  {
    return -1;
  }

  in = BIO_new_file(fname, "rb");
  if (!in)
  {
    return -1;
  }
  *cer = d2i_X509_bio(in, NULL);

  if( NULL == *cer)
  {
     BIO_free(in);
     in = BIO_new_file(fname, "rb");
     PEM_read_bio_X509(in, cer, 0, NULL);
  }

  BIO_free(in);
  return *cer ? 0 : -1;
}

/**
 * @brief Saves X509 certificate to file in PEM format.
 *
 * This method writes X509 certificate to a local file.
 * @param[in]  fname Output file name
 * @param[in] cer    X509
 * @retval 0         on success
 * @retval -1        on error
 */
int der2pem_save(const char *fname, X509 *cer)
{
  BIO *out;
  int res;

  if (!fname || !cer)
  {
    return -1;
  }

  out = BIO_new_file(fname, "wb");
  if (!out)
  {
    return -1;
  }

  res = PEM_write_bio_X509(out, cer);
  BIO_free(out);

  return res ? 0 : -1;
}

/**
 * @brief Converts X509 certificate from DER to PEM format
 *
 * This method performs conversion of X509 certificate into PEM format.
 * @param fin[in]  Source file with X509 certificate in DER form
 * @param fout[in] File to be created with X509 certificate in PEM form
 *
 * @retval 0       On success
 * @retval -1      On error
 */
int der2pem(const char *fin, const char *fout)
{
  X509 *cer = 0;
  if (der2pem_load(fin, &cer))
  {
    return -1;
  }
  if (der2pem_save(fout, cer))
  {
    X509_free(cer);
    return -1;
  }
  X509_free(cer);
  return 0;
}

/**
 * @brief Converts X509 certificate from DER to PEM format
 *
 * This method performs conversion of X509 certificate into PEM format.
 * @param in[in]      Pointer to buffer, containing X509 certificate
 *                    in DER form
 * @param in_size[in] Size of input buffer in bytes
 * @param out[out]    Buffer with certificate data in PEM format. This buffer
 *                    is allocated with malloc() and shall be released using
 *                    free()
 * @param out_size[out] Argument for receiving size of result.
 *
 * @retval 0       On success
 * @retval -1      On error
 */
int der2pem_mem(const void *in, size_t in_size, void **out, size_t *out_size)
{
  X509 *cer = NULL;
  BIO  *bio = NULL;
  size_t size;
  char *data = NULL;

  if (!in || !in_size || !out || !out_size)
  {
    goto err;
  }
  bio = BIO_new_mem_buf((void*)in, in_size);
  if (!bio)
  {
    goto err;
  }
  cer = d2i_X509_bio(bio, NULL);
  BIO_free(bio);
  bio = 0;
  if (!cer)
  {
    goto err;
  }
  bio = BIO_new(BIO_s_mem());
  if (!bio)
  {
    goto err;
  }
  if (!PEM_write_bio_X509(bio, cer))
  {
    goto err;
  }
  X509_free(cer);
  cer = 0;
  size = BIO_get_mem_data(bio, &data);
  *out = malloc(size);
  if (!*out)
  {
    goto err;
  }
  memcpy(*out, data, size);
  BIO_free(bio);
  bio = 0;
  *out_size = size;

  return 0;
err:
  if (bio)
  {
    BIO_free(bio);
  }
  if (cer)
  {
    X509_free(cer);
  }
  return -1;
}

