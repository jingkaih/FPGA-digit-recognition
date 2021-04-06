`timescale 1ns / 1ps


//This module contains the computation steps of 2
//z1 = w1*x + b, where b is the bias which we didn't introduce
//a1 = activation(z1)
//In specific, it also need to extract weights vector from ROM 512 times
//Notice each extraction takes 20ns
//and we do computation almost at the same time

module compute_a1(
    clk, rst_n, run_EN, x, a1, a1_compute_Done
    );
    input clk;
    input rst_n;
    input run_EN;//enable computing impulse. This should be connected to "from_uart_to_layer1.ready_to_compute" in higher level module


    output reg [511:0] a1;//a1 is a 512 bits long vector, 1 is 1, 0 is -1
    output reg a1_compute_Done;//compute done

    input [783:0] x;//x should be connected to "from_uart_to_layer1.x" in higher level module
                    //x is a 784 bits long vector, 1 is 1, 0 is 0
                    //x[783] is the first pixel, x[0] is the last pixel
    
    reg [9:0] addra;//addra ranges from 0 to 511
    wire [783:0] one_row;



    rom_w1_transpose w1_weights(
        .clka(clk),
        .addra(addra),
        .douta(one_row)
    );


    reg addra_add_EN;
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            addra_add_EN <= 0;
        else if(run_EN)
            addra_add_EN <= 1;
        else if(addra == 513)//511
            addra_add_EN <= 0;
        else
            addra_add_EN <= addra_add_EN;
    end
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            addra <= 0;
        else if(addra_add_EN)
            addra <= addra + 1;
        else if(addra == 513)//511
            addra <= 0;
        else
            addra <= 0;
    end


    wire dot_product_0_1;
    element_compute_a1 element_compute_a1_inst(
        .row_vector(one_row),
        .col_vector(x),
        .dot_product_0_1(dot_product_0_1)
    );



    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            a1 <= 0;
        else if(addra_add_EN) begin
            case (addra)
                0,1,2 : a1[ 511 ] <= dot_product_0_1;
                3 : a1[ 510 ] <= dot_product_0_1;
                4 : a1[ 509 ] <= dot_product_0_1;
                5 : a1[ 508 ] <= dot_product_0_1;
                6 : a1[ 507 ] <= dot_product_0_1;
                7 : a1[ 506 ] <= dot_product_0_1;
                8 : a1[ 505 ] <= dot_product_0_1;
                9 : a1[ 504 ] <= dot_product_0_1;
                10 : a1[ 503 ] <= dot_product_0_1;
                11 : a1[ 502 ] <= dot_product_0_1;
                12 : a1[ 501 ] <= dot_product_0_1;
                13 : a1[ 500 ] <= dot_product_0_1;
                14 : a1[ 499 ] <= dot_product_0_1;
                15 : a1[ 498 ] <= dot_product_0_1;
                16 : a1[ 497 ] <= dot_product_0_1;
                17 : a1[ 496 ] <= dot_product_0_1;
                18 : a1[ 495 ] <= dot_product_0_1;
                19 : a1[ 494 ] <= dot_product_0_1;
                20 : a1[ 493 ] <= dot_product_0_1;
                21 : a1[ 492 ] <= dot_product_0_1;
                22 : a1[ 491 ] <= dot_product_0_1;
                23 : a1[ 490 ] <= dot_product_0_1;
                24 : a1[ 489 ] <= dot_product_0_1;
                25 : a1[ 488 ] <= dot_product_0_1;
                26 : a1[ 487 ] <= dot_product_0_1;
                27 : a1[ 486 ] <= dot_product_0_1;
                28 : a1[ 485 ] <= dot_product_0_1;
                29 : a1[ 484 ] <= dot_product_0_1;
                30 : a1[ 483 ] <= dot_product_0_1;
                31 : a1[ 482 ] <= dot_product_0_1;
                32 : a1[ 481 ] <= dot_product_0_1;
                33 : a1[ 480 ] <= dot_product_0_1;
                34 : a1[ 479 ] <= dot_product_0_1;
                35 : a1[ 478 ] <= dot_product_0_1;
                36 : a1[ 477 ] <= dot_product_0_1;
                37 : a1[ 476 ] <= dot_product_0_1;
                38 : a1[ 475 ] <= dot_product_0_1;
                39 : a1[ 474 ] <= dot_product_0_1;
                40 : a1[ 473 ] <= dot_product_0_1;
                41 : a1[ 472 ] <= dot_product_0_1;
                42 : a1[ 471 ] <= dot_product_0_1;
                43 : a1[ 470 ] <= dot_product_0_1;
                44 : a1[ 469 ] <= dot_product_0_1;
                45 : a1[ 468 ] <= dot_product_0_1;
                46 : a1[ 467 ] <= dot_product_0_1;
                47 : a1[ 466 ] <= dot_product_0_1;
                48 : a1[ 465 ] <= dot_product_0_1;
                49 : a1[ 464 ] <= dot_product_0_1;
                50 : a1[ 463 ] <= dot_product_0_1;
                51 : a1[ 462 ] <= dot_product_0_1;
                52 : a1[ 461 ] <= dot_product_0_1;
                53 : a1[ 460 ] <= dot_product_0_1;
                54 : a1[ 459 ] <= dot_product_0_1;
                55 : a1[ 458 ] <= dot_product_0_1;
                56 : a1[ 457 ] <= dot_product_0_1;
                57 : a1[ 456 ] <= dot_product_0_1;
                58 : a1[ 455 ] <= dot_product_0_1;
                59 : a1[ 454 ] <= dot_product_0_1;
                60 : a1[ 453 ] <= dot_product_0_1;
                61 : a1[ 452 ] <= dot_product_0_1;
                62 : a1[ 451 ] <= dot_product_0_1;
                63 : a1[ 450 ] <= dot_product_0_1;
                64 : a1[ 449 ] <= dot_product_0_1;
                65 : a1[ 448 ] <= dot_product_0_1;
                66 : a1[ 447 ] <= dot_product_0_1;
                67 : a1[ 446 ] <= dot_product_0_1;
                68 : a1[ 445 ] <= dot_product_0_1;
                69 : a1[ 444 ] <= dot_product_0_1;
                70 : a1[ 443 ] <= dot_product_0_1;
                71 : a1[ 442 ] <= dot_product_0_1;
                72 : a1[ 441 ] <= dot_product_0_1;
                73 : a1[ 440 ] <= dot_product_0_1;
                74 : a1[ 439 ] <= dot_product_0_1;
                75 : a1[ 438 ] <= dot_product_0_1;
                76 : a1[ 437 ] <= dot_product_0_1;
                77 : a1[ 436 ] <= dot_product_0_1;
                78 : a1[ 435 ] <= dot_product_0_1;
                79 : a1[ 434 ] <= dot_product_0_1;
                80 : a1[ 433 ] <= dot_product_0_1;
                81 : a1[ 432 ] <= dot_product_0_1;
                82 : a1[ 431 ] <= dot_product_0_1;
                83 : a1[ 430 ] <= dot_product_0_1;
                84 : a1[ 429 ] <= dot_product_0_1;
                85 : a1[ 428 ] <= dot_product_0_1;
                86 : a1[ 427 ] <= dot_product_0_1;
                87 : a1[ 426 ] <= dot_product_0_1;
                88 : a1[ 425 ] <= dot_product_0_1;
                89 : a1[ 424 ] <= dot_product_0_1;
                90 : a1[ 423 ] <= dot_product_0_1;
                91 : a1[ 422 ] <= dot_product_0_1;
                92 : a1[ 421 ] <= dot_product_0_1;
                93 : a1[ 420 ] <= dot_product_0_1;
                94 : a1[ 419 ] <= dot_product_0_1;
                95 : a1[ 418 ] <= dot_product_0_1;
                96 : a1[ 417 ] <= dot_product_0_1;
                97 : a1[ 416 ] <= dot_product_0_1;
                98 : a1[ 415 ] <= dot_product_0_1;
                99 : a1[ 414 ] <= dot_product_0_1;
                100 : a1[ 413 ] <= dot_product_0_1;
                101 : a1[ 412 ] <= dot_product_0_1;
                102 : a1[ 411 ] <= dot_product_0_1;
                103 : a1[ 410 ] <= dot_product_0_1;
                104 : a1[ 409 ] <= dot_product_0_1;
                105 : a1[ 408 ] <= dot_product_0_1;
                106 : a1[ 407 ] <= dot_product_0_1;
                107 : a1[ 406 ] <= dot_product_0_1;
                108 : a1[ 405 ] <= dot_product_0_1;
                109 : a1[ 404 ] <= dot_product_0_1;
                110 : a1[ 403 ] <= dot_product_0_1;
                111 : a1[ 402 ] <= dot_product_0_1;
                112 : a1[ 401 ] <= dot_product_0_1;
                113 : a1[ 400 ] <= dot_product_0_1;
                114 : a1[ 399 ] <= dot_product_0_1;
                115 : a1[ 398 ] <= dot_product_0_1;
                116 : a1[ 397 ] <= dot_product_0_1;
                117 : a1[ 396 ] <= dot_product_0_1;
                118 : a1[ 395 ] <= dot_product_0_1;
                119 : a1[ 394 ] <= dot_product_0_1;
                120 : a1[ 393 ] <= dot_product_0_1;
                121 : a1[ 392 ] <= dot_product_0_1;
                122 : a1[ 391 ] <= dot_product_0_1;
                123 : a1[ 390 ] <= dot_product_0_1;
                124 : a1[ 389 ] <= dot_product_0_1;
                125 : a1[ 388 ] <= dot_product_0_1;
                126 : a1[ 387 ] <= dot_product_0_1;
                127 : a1[ 386 ] <= dot_product_0_1;
                128 : a1[ 385 ] <= dot_product_0_1;
                129 : a1[ 384 ] <= dot_product_0_1;
                130 : a1[ 383 ] <= dot_product_0_1;
                131 : a1[ 382 ] <= dot_product_0_1;
                132 : a1[ 381 ] <= dot_product_0_1;
                133 : a1[ 380 ] <= dot_product_0_1;
                134 : a1[ 379 ] <= dot_product_0_1;
                135 : a1[ 378 ] <= dot_product_0_1;
                136 : a1[ 377 ] <= dot_product_0_1;
                137 : a1[ 376 ] <= dot_product_0_1;
                138 : a1[ 375 ] <= dot_product_0_1;
                139 : a1[ 374 ] <= dot_product_0_1;
                140 : a1[ 373 ] <= dot_product_0_1;
                141 : a1[ 372 ] <= dot_product_0_1;
                142 : a1[ 371 ] <= dot_product_0_1;
                143 : a1[ 370 ] <= dot_product_0_1;
                144 : a1[ 369 ] <= dot_product_0_1;
                145 : a1[ 368 ] <= dot_product_0_1;
                146 : a1[ 367 ] <= dot_product_0_1;
                147 : a1[ 366 ] <= dot_product_0_1;
                148 : a1[ 365 ] <= dot_product_0_1;
                149 : a1[ 364 ] <= dot_product_0_1;
                150 : a1[ 363 ] <= dot_product_0_1;
                151 : a1[ 362 ] <= dot_product_0_1;
                152 : a1[ 361 ] <= dot_product_0_1;
                153 : a1[ 360 ] <= dot_product_0_1;
                154 : a1[ 359 ] <= dot_product_0_1;
                155 : a1[ 358 ] <= dot_product_0_1;
                156 : a1[ 357 ] <= dot_product_0_1;
                157 : a1[ 356 ] <= dot_product_0_1;
                158 : a1[ 355 ] <= dot_product_0_1;
                159 : a1[ 354 ] <= dot_product_0_1;
                160 : a1[ 353 ] <= dot_product_0_1;
                161 : a1[ 352 ] <= dot_product_0_1;
                162 : a1[ 351 ] <= dot_product_0_1;
                163 : a1[ 350 ] <= dot_product_0_1;
                164 : a1[ 349 ] <= dot_product_0_1;
                165 : a1[ 348 ] <= dot_product_0_1;
                166 : a1[ 347 ] <= dot_product_0_1;
                167 : a1[ 346 ] <= dot_product_0_1;
                168 : a1[ 345 ] <= dot_product_0_1;
                169 : a1[ 344 ] <= dot_product_0_1;
                170 : a1[ 343 ] <= dot_product_0_1;
                171 : a1[ 342 ] <= dot_product_0_1;
                172 : a1[ 341 ] <= dot_product_0_1;
                173 : a1[ 340 ] <= dot_product_0_1;
                174 : a1[ 339 ] <= dot_product_0_1;
                175 : a1[ 338 ] <= dot_product_0_1;
                176 : a1[ 337 ] <= dot_product_0_1;
                177 : a1[ 336 ] <= dot_product_0_1;
                178 : a1[ 335 ] <= dot_product_0_1;
                179 : a1[ 334 ] <= dot_product_0_1;
                180 : a1[ 333 ] <= dot_product_0_1;
                181 : a1[ 332 ] <= dot_product_0_1;
                182 : a1[ 331 ] <= dot_product_0_1;
                183 : a1[ 330 ] <= dot_product_0_1;
                184 : a1[ 329 ] <= dot_product_0_1;
                185 : a1[ 328 ] <= dot_product_0_1;
                186 : a1[ 327 ] <= dot_product_0_1;
                187 : a1[ 326 ] <= dot_product_0_1;
                188 : a1[ 325 ] <= dot_product_0_1;
                189 : a1[ 324 ] <= dot_product_0_1;
                190 : a1[ 323 ] <= dot_product_0_1;
                191 : a1[ 322 ] <= dot_product_0_1;
                192 : a1[ 321 ] <= dot_product_0_1;
                193 : a1[ 320 ] <= dot_product_0_1;
                194 : a1[ 319 ] <= dot_product_0_1;
                195 : a1[ 318 ] <= dot_product_0_1;
                196 : a1[ 317 ] <= dot_product_0_1;
                197 : a1[ 316 ] <= dot_product_0_1;
                198 : a1[ 315 ] <= dot_product_0_1;
                199 : a1[ 314 ] <= dot_product_0_1;
                200 : a1[ 313 ] <= dot_product_0_1;
                201 : a1[ 312 ] <= dot_product_0_1;
                202 : a1[ 311 ] <= dot_product_0_1;
                203 : a1[ 310 ] <= dot_product_0_1;
                204 : a1[ 309 ] <= dot_product_0_1;
                205 : a1[ 308 ] <= dot_product_0_1;
                206 : a1[ 307 ] <= dot_product_0_1;
                207 : a1[ 306 ] <= dot_product_0_1;
                208 : a1[ 305 ] <= dot_product_0_1;
                209 : a1[ 304 ] <= dot_product_0_1;
                210 : a1[ 303 ] <= dot_product_0_1;
                211 : a1[ 302 ] <= dot_product_0_1;
                212 : a1[ 301 ] <= dot_product_0_1;
                213 : a1[ 300 ] <= dot_product_0_1;
                214 : a1[ 299 ] <= dot_product_0_1;
                215 : a1[ 298 ] <= dot_product_0_1;
                216 : a1[ 297 ] <= dot_product_0_1;
                217 : a1[ 296 ] <= dot_product_0_1;
                218 : a1[ 295 ] <= dot_product_0_1;
                219 : a1[ 294 ] <= dot_product_0_1;
                220 : a1[ 293 ] <= dot_product_0_1;
                221 : a1[ 292 ] <= dot_product_0_1;
                222 : a1[ 291 ] <= dot_product_0_1;
                223 : a1[ 290 ] <= dot_product_0_1;
                224 : a1[ 289 ] <= dot_product_0_1;
                225 : a1[ 288 ] <= dot_product_0_1;
                226 : a1[ 287 ] <= dot_product_0_1;
                227 : a1[ 286 ] <= dot_product_0_1;
                228 : a1[ 285 ] <= dot_product_0_1;
                229 : a1[ 284 ] <= dot_product_0_1;
                230 : a1[ 283 ] <= dot_product_0_1;
                231 : a1[ 282 ] <= dot_product_0_1;
                232 : a1[ 281 ] <= dot_product_0_1;
                233 : a1[ 280 ] <= dot_product_0_1;
                234 : a1[ 279 ] <= dot_product_0_1;
                235 : a1[ 278 ] <= dot_product_0_1;
                236 : a1[ 277 ] <= dot_product_0_1;
                237 : a1[ 276 ] <= dot_product_0_1;
                238 : a1[ 275 ] <= dot_product_0_1;
                239 : a1[ 274 ] <= dot_product_0_1;
                240 : a1[ 273 ] <= dot_product_0_1;
                241 : a1[ 272 ] <= dot_product_0_1;
                242 : a1[ 271 ] <= dot_product_0_1;
                243 : a1[ 270 ] <= dot_product_0_1;
                244 : a1[ 269 ] <= dot_product_0_1;
                245 : a1[ 268 ] <= dot_product_0_1;
                246 : a1[ 267 ] <= dot_product_0_1;
                247 : a1[ 266 ] <= dot_product_0_1;
                248 : a1[ 265 ] <= dot_product_0_1;
                249 : a1[ 264 ] <= dot_product_0_1;
                250 : a1[ 263 ] <= dot_product_0_1;
                251 : a1[ 262 ] <= dot_product_0_1;
                252 : a1[ 261 ] <= dot_product_0_1;
                253 : a1[ 260 ] <= dot_product_0_1;
                254 : a1[ 259 ] <= dot_product_0_1;
                255 : a1[ 258 ] <= dot_product_0_1;
                256 : a1[ 257 ] <= dot_product_0_1;
                257 : a1[ 256 ] <= dot_product_0_1;
                258 : a1[ 255 ] <= dot_product_0_1;
                259 : a1[ 254 ] <= dot_product_0_1;
                260 : a1[ 253 ] <= dot_product_0_1;
                261 : a1[ 252 ] <= dot_product_0_1;
                262 : a1[ 251 ] <= dot_product_0_1;
                263 : a1[ 250 ] <= dot_product_0_1;
                264 : a1[ 249 ] <= dot_product_0_1;
                265 : a1[ 248 ] <= dot_product_0_1;
                266 : a1[ 247 ] <= dot_product_0_1;
                267 : a1[ 246 ] <= dot_product_0_1;
                268 : a1[ 245 ] <= dot_product_0_1;
                269 : a1[ 244 ] <= dot_product_0_1;
                270 : a1[ 243 ] <= dot_product_0_1;
                271 : a1[ 242 ] <= dot_product_0_1;
                272 : a1[ 241 ] <= dot_product_0_1;
                273 : a1[ 240 ] <= dot_product_0_1;
                274 : a1[ 239 ] <= dot_product_0_1;
                275 : a1[ 238 ] <= dot_product_0_1;
                276 : a1[ 237 ] <= dot_product_0_1;
                277 : a1[ 236 ] <= dot_product_0_1;
                278 : a1[ 235 ] <= dot_product_0_1;
                279 : a1[ 234 ] <= dot_product_0_1;
                280 : a1[ 233 ] <= dot_product_0_1;
                281 : a1[ 232 ] <= dot_product_0_1;
                282 : a1[ 231 ] <= dot_product_0_1;
                283 : a1[ 230 ] <= dot_product_0_1;
                284 : a1[ 229 ] <= dot_product_0_1;
                285 : a1[ 228 ] <= dot_product_0_1;
                286 : a1[ 227 ] <= dot_product_0_1;
                287 : a1[ 226 ] <= dot_product_0_1;
                288 : a1[ 225 ] <= dot_product_0_1;
                289 : a1[ 224 ] <= dot_product_0_1;
                290 : a1[ 223 ] <= dot_product_0_1;
                291 : a1[ 222 ] <= dot_product_0_1;
                292 : a1[ 221 ] <= dot_product_0_1;
                293 : a1[ 220 ] <= dot_product_0_1;
                294 : a1[ 219 ] <= dot_product_0_1;
                295 : a1[ 218 ] <= dot_product_0_1;
                296 : a1[ 217 ] <= dot_product_0_1;
                297 : a1[ 216 ] <= dot_product_0_1;
                298 : a1[ 215 ] <= dot_product_0_1;
                299 : a1[ 214 ] <= dot_product_0_1;
                300 : a1[ 213 ] <= dot_product_0_1;
                301 : a1[ 212 ] <= dot_product_0_1;
                302 : a1[ 211 ] <= dot_product_0_1;
                303 : a1[ 210 ] <= dot_product_0_1;
                304 : a1[ 209 ] <= dot_product_0_1;
                305 : a1[ 208 ] <= dot_product_0_1;
                306 : a1[ 207 ] <= dot_product_0_1;
                307 : a1[ 206 ] <= dot_product_0_1;
                308 : a1[ 205 ] <= dot_product_0_1;
                309 : a1[ 204 ] <= dot_product_0_1;
                310 : a1[ 203 ] <= dot_product_0_1;
                311 : a1[ 202 ] <= dot_product_0_1;
                312 : a1[ 201 ] <= dot_product_0_1;
                313 : a1[ 200 ] <= dot_product_0_1;
                314 : a1[ 199 ] <= dot_product_0_1;
                315 : a1[ 198 ] <= dot_product_0_1;
                316 : a1[ 197 ] <= dot_product_0_1;
                317 : a1[ 196 ] <= dot_product_0_1;
                318 : a1[ 195 ] <= dot_product_0_1;
                319 : a1[ 194 ] <= dot_product_0_1;
                320 : a1[ 193 ] <= dot_product_0_1;
                321 : a1[ 192 ] <= dot_product_0_1;
                322 : a1[ 191 ] <= dot_product_0_1;
                323 : a1[ 190 ] <= dot_product_0_1;
                324 : a1[ 189 ] <= dot_product_0_1;
                325 : a1[ 188 ] <= dot_product_0_1;
                326 : a1[ 187 ] <= dot_product_0_1;
                327 : a1[ 186 ] <= dot_product_0_1;
                328 : a1[ 185 ] <= dot_product_0_1;
                329 : a1[ 184 ] <= dot_product_0_1;
                330 : a1[ 183 ] <= dot_product_0_1;
                331 : a1[ 182 ] <= dot_product_0_1;
                332 : a1[ 181 ] <= dot_product_0_1;
                333 : a1[ 180 ] <= dot_product_0_1;
                334 : a1[ 179 ] <= dot_product_0_1;
                335 : a1[ 178 ] <= dot_product_0_1;
                336 : a1[ 177 ] <= dot_product_0_1;
                337 : a1[ 176 ] <= dot_product_0_1;
                338 : a1[ 175 ] <= dot_product_0_1;
                339 : a1[ 174 ] <= dot_product_0_1;
                340 : a1[ 173 ] <= dot_product_0_1;
                341 : a1[ 172 ] <= dot_product_0_1;
                342 : a1[ 171 ] <= dot_product_0_1;
                343 : a1[ 170 ] <= dot_product_0_1;
                344 : a1[ 169 ] <= dot_product_0_1;
                345 : a1[ 168 ] <= dot_product_0_1;
                346 : a1[ 167 ] <= dot_product_0_1;
                347 : a1[ 166 ] <= dot_product_0_1;
                348 : a1[ 165 ] <= dot_product_0_1;
                349 : a1[ 164 ] <= dot_product_0_1;
                350 : a1[ 163 ] <= dot_product_0_1;
                351 : a1[ 162 ] <= dot_product_0_1;
                352 : a1[ 161 ] <= dot_product_0_1;
                353 : a1[ 160 ] <= dot_product_0_1;
                354 : a1[ 159 ] <= dot_product_0_1;
                355 : a1[ 158 ] <= dot_product_0_1;
                356 : a1[ 157 ] <= dot_product_0_1;
                357 : a1[ 156 ] <= dot_product_0_1;
                358 : a1[ 155 ] <= dot_product_0_1;
                359 : a1[ 154 ] <= dot_product_0_1;
                360 : a1[ 153 ] <= dot_product_0_1;
                361 : a1[ 152 ] <= dot_product_0_1;
                362 : a1[ 151 ] <= dot_product_0_1;
                363 : a1[ 150 ] <= dot_product_0_1;
                364 : a1[ 149 ] <= dot_product_0_1;
                365 : a1[ 148 ] <= dot_product_0_1;
                366 : a1[ 147 ] <= dot_product_0_1;
                367 : a1[ 146 ] <= dot_product_0_1;
                368 : a1[ 145 ] <= dot_product_0_1;
                369 : a1[ 144 ] <= dot_product_0_1;
                370 : a1[ 143 ] <= dot_product_0_1;
                371 : a1[ 142 ] <= dot_product_0_1;
                372 : a1[ 141 ] <= dot_product_0_1;
                373 : a1[ 140 ] <= dot_product_0_1;
                374 : a1[ 139 ] <= dot_product_0_1;
                375 : a1[ 138 ] <= dot_product_0_1;
                376 : a1[ 137 ] <= dot_product_0_1;
                377 : a1[ 136 ] <= dot_product_0_1;
                378 : a1[ 135 ] <= dot_product_0_1;
                379 : a1[ 134 ] <= dot_product_0_1;
                380 : a1[ 133 ] <= dot_product_0_1;
                381 : a1[ 132 ] <= dot_product_0_1;
                382 : a1[ 131 ] <= dot_product_0_1;
                383 : a1[ 130 ] <= dot_product_0_1;
                384 : a1[ 129 ] <= dot_product_0_1;
                385 : a1[ 128 ] <= dot_product_0_1;
                386 : a1[ 127 ] <= dot_product_0_1;
                387 : a1[ 126 ] <= dot_product_0_1;
                388 : a1[ 125 ] <= dot_product_0_1;
                389 : a1[ 124 ] <= dot_product_0_1;
                390 : a1[ 123 ] <= dot_product_0_1;
                391 : a1[ 122 ] <= dot_product_0_1;
                392 : a1[ 121 ] <= dot_product_0_1;
                393 : a1[ 120 ] <= dot_product_0_1;
                394 : a1[ 119 ] <= dot_product_0_1;
                395 : a1[ 118 ] <= dot_product_0_1;
                396 : a1[ 117 ] <= dot_product_0_1;
                397 : a1[ 116 ] <= dot_product_0_1;
                398 : a1[ 115 ] <= dot_product_0_1;
                399 : a1[ 114 ] <= dot_product_0_1;
                400 : a1[ 113 ] <= dot_product_0_1;
                401 : a1[ 112 ] <= dot_product_0_1;
                402 : a1[ 111 ] <= dot_product_0_1;
                403 : a1[ 110 ] <= dot_product_0_1;
                404 : a1[ 109 ] <= dot_product_0_1;
                405 : a1[ 108 ] <= dot_product_0_1;
                406 : a1[ 107 ] <= dot_product_0_1;
                407 : a1[ 106 ] <= dot_product_0_1;
                408 : a1[ 105 ] <= dot_product_0_1;
                409 : a1[ 104 ] <= dot_product_0_1;
                410 : a1[ 103 ] <= dot_product_0_1;
                411 : a1[ 102 ] <= dot_product_0_1;
                412 : a1[ 101 ] <= dot_product_0_1;
                413 : a1[ 100 ] <= dot_product_0_1;
                414 : a1[ 99 ] <= dot_product_0_1;
                415 : a1[ 98 ] <= dot_product_0_1;
                416 : a1[ 97 ] <= dot_product_0_1;
                417 : a1[ 96 ] <= dot_product_0_1;
                418 : a1[ 95 ] <= dot_product_0_1;
                419 : a1[ 94 ] <= dot_product_0_1;
                420 : a1[ 93 ] <= dot_product_0_1;
                421 : a1[ 92 ] <= dot_product_0_1;
                422 : a1[ 91 ] <= dot_product_0_1;
                423 : a1[ 90 ] <= dot_product_0_1;
                424 : a1[ 89 ] <= dot_product_0_1;
                425 : a1[ 88 ] <= dot_product_0_1;
                426 : a1[ 87 ] <= dot_product_0_1;
                427 : a1[ 86 ] <= dot_product_0_1;
                428 : a1[ 85 ] <= dot_product_0_1;
                429 : a1[ 84 ] <= dot_product_0_1;
                430 : a1[ 83 ] <= dot_product_0_1;
                431 : a1[ 82 ] <= dot_product_0_1;
                432 : a1[ 81 ] <= dot_product_0_1;
                433 : a1[ 80 ] <= dot_product_0_1;
                434 : a1[ 79 ] <= dot_product_0_1;
                435 : a1[ 78 ] <= dot_product_0_1;
                436 : a1[ 77 ] <= dot_product_0_1;
                437 : a1[ 76 ] <= dot_product_0_1;
                438 : a1[ 75 ] <= dot_product_0_1;
                439 : a1[ 74 ] <= dot_product_0_1;
                440 : a1[ 73 ] <= dot_product_0_1;
                441 : a1[ 72 ] <= dot_product_0_1;
                442 : a1[ 71 ] <= dot_product_0_1;
                443 : a1[ 70 ] <= dot_product_0_1;
                444 : a1[ 69 ] <= dot_product_0_1;
                445 : a1[ 68 ] <= dot_product_0_1;
                446 : a1[ 67 ] <= dot_product_0_1;
                447 : a1[ 66 ] <= dot_product_0_1;
                448 : a1[ 65 ] <= dot_product_0_1;
                449 : a1[ 64 ] <= dot_product_0_1;
                450 : a1[ 63 ] <= dot_product_0_1;
                451 : a1[ 62 ] <= dot_product_0_1;
                452 : a1[ 61 ] <= dot_product_0_1;
                453 : a1[ 60 ] <= dot_product_0_1;
                454 : a1[ 59 ] <= dot_product_0_1;
                455 : a1[ 58 ] <= dot_product_0_1;
                456 : a1[ 57 ] <= dot_product_0_1;
                457 : a1[ 56 ] <= dot_product_0_1;
                458 : a1[ 55 ] <= dot_product_0_1;
                459 : a1[ 54 ] <= dot_product_0_1;
                460 : a1[ 53 ] <= dot_product_0_1;
                461 : a1[ 52 ] <= dot_product_0_1;
                462 : a1[ 51 ] <= dot_product_0_1;
                463 : a1[ 50 ] <= dot_product_0_1;
                464 : a1[ 49 ] <= dot_product_0_1;
                465 : a1[ 48 ] <= dot_product_0_1;
                466 : a1[ 47 ] <= dot_product_0_1;
                467 : a1[ 46 ] <= dot_product_0_1;
                468 : a1[ 45 ] <= dot_product_0_1;
                469 : a1[ 44 ] <= dot_product_0_1;
                470 : a1[ 43 ] <= dot_product_0_1;
                471 : a1[ 42 ] <= dot_product_0_1;
                472 : a1[ 41 ] <= dot_product_0_1;
                473 : a1[ 40 ] <= dot_product_0_1;
                474 : a1[ 39 ] <= dot_product_0_1;
                475 : a1[ 38 ] <= dot_product_0_1;
                476 : a1[ 37 ] <= dot_product_0_1;
                477 : a1[ 36 ] <= dot_product_0_1;
                478 : a1[ 35 ] <= dot_product_0_1;
                479 : a1[ 34 ] <= dot_product_0_1;
                480 : a1[ 33 ] <= dot_product_0_1;
                481 : a1[ 32 ] <= dot_product_0_1;
                482 : a1[ 31 ] <= dot_product_0_1;
                483 : a1[ 30 ] <= dot_product_0_1;
                484 : a1[ 29 ] <= dot_product_0_1;
                485 : a1[ 28 ] <= dot_product_0_1;
                486 : a1[ 27 ] <= dot_product_0_1;
                487 : a1[ 26 ] <= dot_product_0_1;
                488 : a1[ 25 ] <= dot_product_0_1;
                489 : a1[ 24 ] <= dot_product_0_1;
                490 : a1[ 23 ] <= dot_product_0_1;
                491 : a1[ 22 ] <= dot_product_0_1;
                492 : a1[ 21 ] <= dot_product_0_1;
                493 : a1[ 20 ] <= dot_product_0_1;
                494 : a1[ 19 ] <= dot_product_0_1;
                495 : a1[ 18 ] <= dot_product_0_1;
                496 : a1[ 17 ] <= dot_product_0_1;
                497 : a1[ 16 ] <= dot_product_0_1;
                498 : a1[ 15 ] <= dot_product_0_1;
                499 : a1[ 14 ] <= dot_product_0_1;
                500 : a1[ 13 ] <= dot_product_0_1;
                501 : a1[ 12 ] <= dot_product_0_1;
                502 : a1[ 11 ] <= dot_product_0_1;
                503 : a1[ 10 ] <= dot_product_0_1;
                504 : a1[ 9 ] <= dot_product_0_1;
                505 : a1[ 8 ] <= dot_product_0_1;
                506 : a1[ 7 ] <= dot_product_0_1;
                507 : a1[ 6 ] <= dot_product_0_1;
                508 : a1[ 5 ] <= dot_product_0_1;
                509 : a1[ 4 ] <= dot_product_0_1;
                510 : a1[ 3 ] <= dot_product_0_1;
                511 : a1[ 2 ] <= dot_product_0_1;
                512 : a1[ 1 ] <= dot_product_0_1;
                513 : a1[ 0 ] <= dot_product_0_1;
            endcase
        end
    end
    

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            a1_compute_Done <= 0;
        else if(addra == 513)
            a1_compute_Done <= 1;
        else
            a1_compute_Done <= 0;
    end

endmodule