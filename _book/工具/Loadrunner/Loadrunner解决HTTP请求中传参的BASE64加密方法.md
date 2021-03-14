# Loadrunner解决HTTP请求中传参的BASE64加密方法

用于web请求中参数的传参值涉及到了base64加密方法

```
void GetBase64Encode(const char* in_str,char* out_str)//加密方法
{
    static unsigned char base64[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    int curr_out_len = 0;
    int i = 0;
    int in_len = strlen(in_str);
    unsigned char a, b, c;
    out_str[0] = '\0';
    if (in_len > 0)
    {
       while (i < in_len)
       {
        a = in_str[i];
        b = (i + 1 >= in_len) ? 0 : in_str[i + 1];
        c = (i + 2 >= in_len) ? 0 : in_str[i + 2];
        if (i + 2 < in_len)
        {
         out_str[curr_out_len++] = (base64[(a >> 2) & 0x3F]);
         out_str[curr_out_len++] = (base64[((a << 4) & 0x30) + ((b >> 4) & 0xf)]);
         out_str[curr_out_len++] = (base64[((b << 2) & 0x3c) + ((c >> 6) & 0x3)]);
         out_str[curr_out_len++] = (base64[c & 0x3F]);
        }
        else if (i + 1 < in_len)
        {
         out_str[curr_out_len++] = (base64[(a >> 2) & 0x3F]);
         out_str[curr_out_len++] = (base64[((a << 4) & 0x30) + ((b >> 4) & 0xf)]);
         out_str[curr_out_len++] = (base64[((b << 2) & 0x3c) + ((c >> 6) & 0x3)]);
         out_str[curr_out_len++] = '=';
        }
        else
        {
         out_str[curr_out_len++] = (base64[(a >> 2) & 0x3F]);
         out_str[curr_out_len++] = (base64[((a << 4) & 0x30) + ((b >> 4) & 0xf)]);
         out_str[curr_out_len++] = '=';
         out_str[curr_out_len++] = '=';
        }
        i += 3;
       }
       out_str[curr_out_len] = '\0';
    }
}
Action()
{
    char * take;
    char * toke;
    char res[512];
    take=(char *)strtok(lr_eval_string("{GUID}"),"{");//格式化“{”字符串
    toke=(char *)strtok(take,"}");//格式化“}”字符串，并将值存入toke中
    lr_error_message("GUID: %s",toke);
    GetBase64Encode(toke,res);//调用base64函数
    lr_output_message(res);
    return 0;
}

```