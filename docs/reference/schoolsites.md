# Schooldata Sites

Descriptors for the sites of the
[`schooldata`](https://friendly.github.io/heplots/reference/schooldata.md)
dataset, from Charnes et al. (1981). The study was designed to compare
schools using Program Follow Through (PFT) management methods of taking
actions to achieve goals with those of Non Follow Through (NFT).
Observations `1:49` came from PFT sites and `50:70` from NFT sites. This
dataset gives other descriptors for the sites, from their Exhibit C.

## Usage

``` r
data("schoolsites")
```

## Format

A data frame with 70 observations on the following 7 variables.

- `site`:

  site number, a numeric vector

- `type`:

  program type, a factor with levels `PFT` ("Program Follow Through")
  and `NFT` ("Non Follow Through")

- `model`:

  education style model, a factor with levels `BA`, `Bank Street`,
  `California Process`, `Cognitive Curriculum`, `DIM`, `EDC`,
  `Home-School`, `ILM`, `Parent Education`, `Responsive Education`,
  `SEDL`, `TEEM`

- `site_name`:

  location of site, a character vector

- `region`:

  US region, a factor with levels `NC`, `NE`, `S`, `W`

- `city_size`:

  city size, an ordered factor with levels `Rural` \< `Small` \<
  `Medium` \< `Large`

- `student_pop`:

  size of the student population, a numeric vector

% @details %% \~~ If necessary, more details than the **description**
above \~~

## Source

A. Charnes, W.W. Cooper and E. Rhodes (1981). Evaluating Program and
Managerial Efficiency: An Application of Data Envelopment Analysis to
Program Follow Through. *Management Science*, **27**, 668-697, Exhibit
C.

## See also

[`schooldata`](https://friendly.github.io/heplots/reference/schooldata.md)

## Examples

``` r
data(schoolsites)
str(schoolsites)
#> 'data.frame':    70 obs. of  7 variables:
#>  $ site       : int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ type       : Factor w/ 2 levels "PFT","NFT": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ model      : Factor w/ 12 levels "BA","Bank Street",..: 10 10 10 10 10 10 10 12 12 12 ...
#>  $ site_name  : chr  "Berkeley, CA" "Buffalo, NY" "Duluth, MN" "Fresno, CA" ...
#>  $ region     : Factor w/ 4 levels "NC","NE","S",..: 4 2 1 4 2 4 4 3 2 1 ...
#>  $ city_size  : Ord.factor w/ 4 levels "Rural"<"Small"<..: 3 4 3 3 1 3 3 4 2 3 ...
#>  $ student_pop: int  99 77 77 48 14 36 51 99 80 96 ...
schools <- cbind(schooldata, schoolsites)
schools.mod <- lm(cbind(reading, mathematics, selfesteem) ~
                    education + occupation + visit + counseling + teacher +
                    type + region, data = schools)
car::Anova(schools.mod)
#> 
#> Type II MANOVA Tests: Pillai test statistic
#>            Df test stat approx F num Df den Df    Pr(>F)    
#> education   1   0.37965  11.8320      3     58 3.773e-06 ***
#> occupation  1   0.53605  22.3376      3     58 9.720e-10 ***
#> visit       1   0.26933   7.1264      3     58 0.0003721 ***
#> counseling  1   0.07204   1.5008      3     58 0.2238866    
#> teacher     1   0.01106   0.2163      3     58 0.8847243    
#> type        1   0.10345   2.2307      3     58 0.0942228 .  
#> region      3   0.26764   1.9591      9    180 0.0465145 *  
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
