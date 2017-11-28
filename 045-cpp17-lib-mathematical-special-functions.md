# 数学の特殊関数群

C++17では数学の特殊関数群（mathematical special functions）がヘッダーファイル`<cmath>`に追加された。

数学の特殊関数は、いずれも実引数を取って、規定の計算をし、結果を浮動小数点数型の戻り値として返す。

数学の特殊関数は`double`, `float`, `long double`型の3つのオーバーロードがある。それぞれ、関数名の最後に、何もなし、`f`, `l`というサフィックスで表現されている。

~~~c++
double      function_name() ;   // 何もなし
float       function_namef() ;  // f
long double function_namel() ;  // l
~~~

数学の特殊関数の説明は、関数の宣言、効果、戻り値、注意がある。


もし、数学の特殊関数に渡した実引数がNaN（Not a Number）である場合、関数の戻り値もNaNになる。ただし定義域エラーは起こらない。

それ以外の場合で、関数が定義域エラーを返すべきときは、

+   関数の戻り値の記述で、定義域が示されていて実引数が示された定義域を超えるとき
+   実引数に対応する数学関数の結果の値が非ゼロの虚数部を含むとき
+   実引数に対応する数学関数の結果の値が数学的に定義されていないとき

別途示されていない場合、関数はすべての有限の値、負の無限大、正の無限大に対しても定義されている。

数学関数が与えられた実引数の値に対して定義されているというとき、それは以下のいずれかである。

+ 実引数の値の集合に対して明示的に定義されている
+ 計算方法に依存しない極限値が存在する

ある関数の効果が実装定義（implementation-defined）である場合、その効果はC++標準規格で定義されず、C++実装はどのように実装してもよいという意味だ。

## ラゲール多項式（Laguerre polynomials）

~~~c++
double       laguerre(unsigned n, double x);
float        laguerref(unsigned n, float x);
long double  laguerrel(unsigned n, long double x);
~~~

__効果__：実引数`n`, `x`に対するラゲール多項式（Laguerre polynomials）を計算する。

__戻り値__：

$$
  \mathsf{L}_n(x) =
  \frac{e^x}{n!} \frac{ \mathsf{d} ^ n}
		    { \mathsf{d}x ^ n} \, (x^n e^{-x}),
	   \quad \mbox{for $x \ge 0$}
$$

$n$を`n`, $x$を`x`とする。

__注意__： `n` \>= 128のときの関数の呼び出しの効果は実装定義である。


## ラゲール陪多項式（Associated Laguerre polynomials）

~~~c++
double      assoc_laguerre(unsigned n, unsigned m, double x);
float       assoc_laguerref(unsigned n, unsigned m, float x);
long double assoc_laguerrel(unsigned n, unsigned m, long double x);
~~~

__効果__：実引数`n`, `m`, `x`に対するラゲール陪多項式（Associated Laguerre polynomials）を計算する。

__戻り値__：

$$
  \mathsf{L}_n^m(x) =
  (-1)^m \frac{\mathsf{d} ^ m}
	   {\mathsf{d}x ^ m} \, \mathsf{L}_{n+m}(x),
	   \quad \mbox{for $x \ge 0$}
$$

$n$を`n`, $m$を`m`, $x$を`x`とする。

__注意__：`n` \>= 128 もしくは `m` \>= 128 のときの関数呼び出しの効果は実装定義である。


## ルジャンドル多項式（Legendre polynomials）

~~~c++
double       legendre(unsigned l, double x);
float        legendref(unsigned l, float x);
long double  legendrel(unsigned l, long double x);
~~~

__効果__：実引数`l`, `x`に対するルジャンドル多項式（Legendre polynomials）を計算する。

__戻り値__：

$$
  \mathsf{P}_\ell(x) =
  \frac{1}
       {2^\ell \, \ell!}
  \frac{ \mathsf{d} ^ \ell}
       { \mathsf{d}x ^ \ell} \, (x^2 - 1) ^ \ell,
	   \quad \mbox{for $|x| \le 1$}
$$

$l$を`l`, $x$を`x`とする。

__注意__：`l` \>= 128 のときの関数の呼び出しの効果は実装定義である。


## ルジャンドル陪関数（Associated Legendre functions）{#sf.cmath.assoc_legendre}

~~~c++
double      assoc_legendre(unsigned l, unsigned m, double x);
float       assoc_legendref(unsigned l, unsigned m, float x);
long double assoc_legendrel(unsigned l, unsigned m, long double x);
~~~

__効果__：実引数`l`, `m`, `x`に対するルジャンドル陪関数（Associated Legendre functions）を計算する。

__戻り値__：

$$
  \mathsf{P}_\ell^m(x) =
  (1 - x^2) ^ {m/2}
  \:
  \frac{ \mathsf{d} ^ m}
       { \mathsf{d}x ^ m} \, \mathsf{P}_\ell(x),
	   \quad \mbox{for $|x| \le 1$}
$$

$l$を`l`, $m$を`m`, $x$を`x`とする。

__注意__：`l` \>= 128 のときの関数呼び出しの効果は実装定義である。

## 球面ルジャンドル陪関数（Spherical associated Legendre functions）

~~~c++
double       sph_legendre(  unsigned l, unsigned m, double theta);
float        sph_legendref( unsigned l, unsigned m, float theta);
long double  sph_legendrel( unsigned l, unsigned m,
                            long double theta);
~~~

__効果__：実引数`l`, `m`, `theta`（`theta`の単位はラジアン）に対する球面ルジャンドル陪関数（Spherical associated Legendre functions）を計算する。

__戻り値__：

$$
  \mathsf{Y}_\ell^m(\theta, 0)
$$

このとき、

$$
  \mathsf{Y}_\ell^m(\theta, \phi) =
  (-1)^m \left[ \frac{(2 \ell + 1)}
                     {4 \pi}
	        \frac{(\ell - m)!}
	             {(\ell + m)!}
         \right]^{1/2}
	 \mathsf{P}_\ell^m
	 ( \cos\theta ) e ^ {i m \phi},
	   \quad \mbox{for $|m| \le \ell$}
$$

$l$を`l`, $m$を`m`, $\theta$を`theta`とする。

__注意__：`l` \>= 128 のときの関数の呼び出しの効果は実装定義である。

球面調和関数（Spherical harmonics） $\mathsf{Y}_\ell^m(\theta, \phi)$ は、以下のような関数を定義することによって計算できる。

```c++
#include <cmath>
#include <complex>

std::complex<double>
spherical_harmonics(unsigned l, unsigned m, double theta, double phi)
{
    return std::sph_legendre(l, m, theta) * std::polar(1.0, m * phi) ;
}
```

[ルジャンドル陪関数](#sf.cmath.assoc_legendre)も参照。


## エルミート多項式（Hermite polynomials）

~~~c++
double       hermite(unsigned n, double x);
float        hermitef(unsigned n, float x);
long double  hermitel(unsigned n, long double x);
~~~

__効果__：実引数`n`, `x`に対するエルミート多項式（Hermite polynomials）を計算する。

__戻り値__：

$$
  \mathsf{H}_n(x) =
  (-1)^n e^{x^2} \frac{ \mathsf{d} ^n}
		      { \mathsf{d}x^n} \, e^{-x^2}
\;
$$

$n$を`n`, $x$を`x`とする。

__注意__：`n` \>= 128 のときの関数の呼び出しの効果は実装定義である。


## ベータ関数（Beta function）

~~~c++
double      beta(double x, double y);
float       betaf(float x, float y);
long double betal(long double x, long double y);
~~~

__効果__：実引数`x`, `y`に対するベータ関数（Beta function）を計算する。

__戻り値__：

$$
  \mathsf{B}(x, y) =
  \frac{ \Gamma(x) \, \Gamma(y) }
       { \Gamma(x+y) },
       \quad \mbox{for $x > 0$,\, $y > 0$}
$$

$x$を`x`, $y$を`y`とする。


## 第1種完全楕円積分（Complete elliptic integral of the first kind）

~~~c++
double      comp_ellint_1(double k);
float       comp_ellint_1f(float k);
long double comp_ellint_1l(long double k);
~~~

__効果__：実引数`k`に対する第1種完全楕円積分（Complete elliptic integral of the first kind）を計算する。

__戻り値__：

$$
  \mathsf{K}(k) =
  \mathsf{F}(k, \pi / 2),
		      \quad \mbox{for $|k| \le 1$}
$$

$k$を`k`とする。

[第1種不完全楕円積分](#sf.cmath.ellint_1)も参照。

## 第2種完全楕円積分（Complete elliptic integral of the second kind）

~~~c++
double      comp_ellint_2(double k);
float       comp_ellint_2f(float k);
long double comp_ellint_2l(long double k);
~~~

__効果__：実引数`k`に対する第2種完全楕円積分（Complete elliptic integral of the second kind）を計算する。

__戻り値__：

$$
  \mathsf{E}(k) =
  \mathsf{E}(k, \pi / 2),
\quad \mbox{for $|k| \le 1$}
$$

$k$を`k`とする。

[第2種不完全楕円積分](#sf.cmath.ellint_2)も参照。

## 第3種完全楕円積分（Complete elliptic integral of the third kind）

~~~c++
double      comp_ellint_3(double k, double nu);
float       comp_ellint_3f(float k, float nu);
long double comp_ellint_3l(long double k, long double nu);
~~~

__効果__：実引数`k`, `nu`に対する第3種完全楕円積分（Complete elliptic integral of the third kind）を計算する。

__戻り値__：

$$
  \mathsf{\Pi}(\nu, k) = \mathsf{\Pi}(\nu, k, \pi / 2),
		\quad \mbox{for $|k| \le 1$}
$$

$k$を`k`, $\nu$を`nu`とする。

[第3種不完全楕円積分](#sf.cmath.ellint_3)も参照。

## 第1種不完全楕円積分（Incomplete elliptic integral of the first kind） {#sf.cmath.ellint_1}

~~~c++
double       ellint_1(double k, double phi);
float        ellint_1f(float k, float phi);
long double  ellint_1l(long double k, long double phi);
~~~

__効果__：実引数`k`, `phi`（`phi`の単位はラジアン）に対する第1種不完全楕円積分（Incomplete elliptic integral of the first kind）を計算する。

__戻り値__：

$$
  \mathsf{F}(k, \phi) =
  \int_0^\phi \! \frac{\mathsf{d}\theta}
                      {\sqrt{1 - k^2 \sin^2 \theta}},
	   \quad \mbox{for $|k| \le 1$}
$$

$k$を`k`, $\phi$を`phi`とする。


## 第2種不完全楕円積分（Incomplete elliptic integroal of the second kind） {#sf.cmath.ellint_2}

~~~c++
double       ellint_2(double k, double phi);
float        ellint_2f(float k, float phi);
long double  ellint_2l(long double k, long double phi);
~~~

__効果__：実引数`k`, `phi`（`phi`の単位はラジアン）に対する第2種不完全楕円積分（Incomplete elliptic integral of the second kind）を計算する。

__戻り値__：

$$
  \mathsf{E}(k, \phi) =
  \int_0^\phi \! \sqrt{1 - k^2 \sin^2 \theta} \, \mathsf{d}\theta,
	   \quad \mbox{for $|k| \le 1$}
$$


$k$を`k`, $\phi$を`phi`とする。


## 第3種不完全楕円積分（Incomplete elliptic integral of the third kind） {#sf.cmath.ellint_3}

~~~c++
double       ellint_3(  double k, double nu, double phi);
float        ellint_3f( float k, float nu, float phi);
long double  ellint_3l( long double k, long double nu,
                        long double phi);
~~~

__効果__：実引数`k`, `nu`, `phi`（`phi`の単位はラジアン）に対する第3種不完全楕円積分（Incomplete elliptic integral of the third kind）を計算する。

__戻り値__：

$$
  \mathsf{\Pi}(\nu, k, \phi) =
  \int_0^\phi \! \frac{ \mathsf{d}\theta }
                      { (1 - \nu \, \sin^2 \theta) \sqrt{1 - k^2 \sin^2 \theta} },
	   \quad \mbox{for $|k| \le 1$}
$$

$\nu$を`nu`, $k$を`k`, $\phi$を`phi`とする。


## 第1種ベッセル関数（Cylindrical Bessel functions of the first kind） {#sf.cmath.cyl_bessel_j}

~~~c++
double       cyl_bessel_j(double nu, double x);
float        cyl_bessel_jf(float nu, float x);
long double  cyl_bessel_jl(long double nu, long double x);
~~~

__効果__：実引数`nu`, `k`に対する第1種ベッセル関数（Cylindrical Bessel functions of the first kind, Bessel functions of the first kind）を計算する。

__戻り値__：

$$
  \mathsf{J}_\nu(x) =
  \sum_{k=0}^\infty \frac{(-1)^k (x/2)^{\nu+2k}}
			 {k! \: \Gamma(\nu+k+1)},
	   \quad \mbox{for $x \ge 0$}
$$

$\nu$を`nu`, $x$を`x`とする。

__注意__：`nu` \>= 128 のときの関数の呼び出しの効果は実装定義である。

## ノイマン関数（Cylindrical Neumann functions） {#sf.cmath.cyl_neumann}

~~~c++
double       cyl_neumann(double nu, double x);
float        cyl_neumannf(float nu, float x);
long double  cyl_neumannl(long double nu, long double x);
~~~

__効果__：実引数`nu`, `x`に対するノイマン関数（Cylindrical Neumann functions, Neumann functions）、またの名を第2種ベッセル関数（Cylindrical Bessel functions of the second kind, Bessel functions of the second kind）を計算する。

__戻り値__：

$$
  \mathsf{N}_\nu(x) =
  \left\{
  \begin{array}{cl}
  \displaystyle
  \frac{\mathsf{J}_\nu(x) \cos \nu\pi - \mathsf{J}_{-\nu}(x)}
       {\sin \nu\pi },
  & \mbox{for $x \ge 0$ and non-integral $\nu$}
  \\
  \\
  \displaystyle
  \lim_{\mu \rightarrow \nu} \frac{\mathsf{J}_\mu(x) \cos \mu\pi - \mathsf{J}_{-\mu}(x)}
                                {\sin \mu\pi },
  & \mbox{for $x \ge 0$ and integral $\nu$}
  \end{array}
  \right.
$$

$\nu$を`nu`, $x$を`x`とする。

__注意__：`nu` \>= 128 のときの関数の呼び出しの効果は実装定義である。

[第1種ベッセル関数](#sf.cmath.cyl_bessel_j)も参照。


## 第1種変形ベッセル関数（Regular modified cylindrical Bessel functions） {#sf.cmath.cyl_bessel_i}

~~~c++
double       cyl_bessel_i(double nu, double x);
float        cyl_bessel_if(float nu, float x);
long double  cyl_bessel_il(long double nu, long double x);
~~~

__効果__：実引数`nu`, `x`に対する第1種変形ベッセル関数（Regular modified cylindrical Bessel functions, Modified Bessel functions of the first kind）を計算する。

__戻り値__：

$$
  \mathsf{I}_\nu(x) =
  \mathrm{i}^{-\nu} \mathsf{J}_\nu(\mathrm{i}x)
  =
  \sum_{k=0}^\infty \frac{(x/2)^{\nu+2k}}
			 {k! \: \Gamma(\nu+k+1)},
	   \quad \mbox{for $x \ge 0$}
$$

$\nu$を`nu`, $x$を`x`とする。

__注意__：`nu` \>= 128 のときの関数の呼び出しの効果は実装定義である。

[第1種ベッセル関数](#sf.cmath.cyl_bessel_j)も参照。

## 第2種変形ベッセル関数（Irregular modified cylindrical Bessel functions）

~~~c++
double       cyl_bessel_k(double nu, double x);
float        cyl_bessel_kf(float nu, float x);
long double  cyl_bessel_kl(long double nu, long double x);
~~~

__効果__：実引数`nu`, `x`に対する第2種変形ベッセル関数（Irregular modified cylindrical Bessel functions, Modified Bessel functions of the second kind）を計算する。

__戻り値__：

$$
  \mathsf{K}_\nu(x) =
  (\pi/2)\mathrm{i}^{\nu+1} (            \mathsf{J}_\nu(\mathrm{i}x)
			    + \mathrm{i} \mathsf{N}_\nu(\mathrm{i}x)
			    )
  =
  \left\{
  \begin{array}{cl}
  \displaystyle
  \frac{\pi}{2}
  \frac{\mathsf{I}_{-\nu}(x) - \mathsf{I}_{\nu}(x)}
       {\sin \nu\pi },
  & \mbox{for $x \ge 0$ and non-integral $\nu$}
  \\
  \\
  \displaystyle
  \frac{\pi}{2}
  \lim_{\mu \rightarrow \nu} \frac{\mathsf{I}_{-\mu}(x) - \mathsf{I}_{\mu}(x)}
                                  {\sin \mu\pi },
  & \mbox{for $x \ge 0$ and integral $\nu$}
  \end{array}
  \right.
$$

$\nu$を`nu`, $x$を`x`とする。

__注意__：`nu` \>= 128 のときの関数の呼び出しの効果は実装定義である。

[第1種変形ベッセル関数](#sf.cmath.cyl_bessel_i)、[第1種ベッセル関数](#sf.cmath.cyl_bessel_j)、[ノイマン関数](#sf.cmath.cyl_neumann)も参照。


## 第1種球ベッセル関数（Spherical Bessel functions of the first kind）

~~~c++
double       sph_bessel(unsigned n, double x);
float        sph_besself(unsigned n, float x);
long double  sph_bessell(unsigned n, long double x);
~~~

__効果__：実引数`n`, `x`に対する第1種球ベッセル関数（Spherical Bessel functions of the first kind）を計算する。

__戻り値__：

$$
  \mathsf{j}_n(x) =
  (\pi/2x)^{1\!/\!2} \mathsf{J}_{n + 1\!/\!2}(x),
	   \quad \mbox{for $x \ge 0$}
$$

__注意__： `n` \>= 128 のときの関数の呼び出しの効果は実装定義である。

[第1種ベッセル関数](#sf.cmath.cyl_bessel_j)も参照。

## 球ノイマン関数（Spherical Neumann functions）

~~~c++
double       sph_neumann(unsigned n, double x);
float        sph_neumannf(unsigned n, float x);
long double  sph_neumannl(unsigned n, long double x);
~~~

__効果__：実引数`n`, `x`に対する球ノイマン関数（Spherical Neumann functions）、またの名を第2種球ベッセル関数（Spherical Bessel functions of the second kind）を計算する。

__戻り値__：

$$
  \mathsf{n}_n(x) =
  (\pi/2x)^{1\!/\!2} \mathsf{N}_{n + 1\!/\!2}(x),
	   \quad \mbox{for $x \ge 0$}
$$

$n$を`n`, $x$を`x`とする。

__注意__：`n` \>= 128 のときの関数の呼び出しの効果は実装定義である。

[ノイマン関数](#sf.cmath.cyl_neumann)も参照。


## 指数積分（Exponential integral）

~~~c++
double       expint(double x);
float        expintf(float x);
long double  expintl(long double x);
~~~

__効果__：実引数`x`に対する指数積分（Exponential integral）を計算する。

__戻り値__：

$$
  \mathsf{Ei}(x) =
  - \int_{-x}^\infty \frac{e^{-t}}
                          {t     } \, \mathsf{d}t
\;
$$

$x$を`x`とする。


## リーマンゼータ関数（Riemann zeta function）

~~~c++
double       riemann_zeta(double x);
float        riemann_zetaf(float x);
long double  riemann_zetal(long double x);
~~~

__効果__：実引数`x`に対するリーマンゼータ関数（Riemann zeta function）を計算する。

__戻り値__：

$$
  \mathsf{\zeta}(x) =
  \left\{
  \begin{array}{cl}
  \displaystyle
  \sum_{k=1}^\infty k^{-x},
  & \mbox{for $x > 1$}
  \\
  \\
  \displaystyle
  \frac{1}
	{1 - 2^{1-x}}
  \sum_{k=1}^\infty (-1)^{k-1} k^{-x},
  & \mbox{for $0 \le x \le 1$}
  \\
  \\
  \displaystyle
  2^x \pi^{x-1} \sin(\frac{\pi x}{2}) \, \Gamma(1-x) \, \zeta(1-x),
  & \mbox{for $x < 0$}
  \end{array}
  \right.
\;
$$

$x$を`x`とする。
