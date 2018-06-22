require(sfsmisc)

setwd('~/compwork/postgres/spherical/')

get_results = function(filename){
  o = scan(filename, list(n=0,t=0,bread=0,bhit=0,ball=0))

  o$T = Reduce(function(i, v) i+v, o$t, accumulate=TRUE)

  o
}

pg_o5 = get_results('out_run_pg_1000_100000')

q3c_o5 = get_results('out_run_q3c_1000_100000')

pg2_o5 = get_results('out_run_pg112_1000_100000')
pg5_o5 = get_results('out_run_pg115_1000_100000')

h_o5 = get_results('out_run_haversine_1000_100000')
postgis_o5 = get_results('out_run_postgis_1000_100000')

#png('fig_run_number_time.png', width=1024, height=768)

plot(q3c_o5$n, q3c_o5$T, type="s", col="green", log="xy", lty=1, ylim=c(1e2, 1e8),
     xlab="Total number of points", ylab="Total time, ms", lwd=2, axes=FALSE)
box()
eaxis(1)
eaxis(2)
lines(pg_o5$n, pg_o5$T, type="s", col="red", lty=1, lwd=2)
lines(pg2_o5$n, pg2_o5$T, type="s", col="blue", lty=1, lwd=2)
lines(pg5_o5$n, pg5_o5$T, type="s", col="magenta", lty=1, lwd=2)
lines(h_o5$n, h_o5$T, type="s", col="black", lty=1, lwd=2)
lines(postgis_o5$n, postgis_o5$T, type="s", col="gray", lty=1, lwd=2)
legend(1e5, 1e7, box.lty=0,
       c("Q3C / chunk=100000",
         "pgSphere 1.1.1 / chunk=100000",
         "pgSphere 1.1.2 / chunk=100000", "pgSphere 1.1.5+spoint2 / chunk=100000", "haversine / chunk=100000", "PostGIS 2.1 / chunk=100000"),
       col = c("green", "red", "blue", "magenta", "black", "gray"),
       lty = c(1,1,1,1,1,1))

#dev.off()

stop()

#png('fig_run_number_time_differential.png', width=1024, height=768)

plot(q3c_o5$n, q3c_o5$t, type="p", col="green", log="xy", pch=2, cex=0.3, ylim=c(1e2, 1e5),
     xlab="Total number of points", ylab="Insertion time, ms", axes=FALSE)
box()
eaxis(1)
eaxis(2)
lines(pg_o5$n, pg_o5$t, type="p", col="red", pch=2, cex=0.3)
lines(pg2_o5$n, pg2_o5$t, type="p", col="blue", pch=2, cex=0.3)
lines(pg5_o5$n, pg5_o5$t, type="p", col="magenta", pch=2, cex=0.3)
lines(h_o5$n, h_o5$t, type="p", col="black", pch=2, cex=0.3)
lines(postgis_o5$n, postgis_o5$t, type="p", col="gray", pch=2, cex=0.3)
legend(1e5, 1e5, box.lty=0,
       c("Q3C / chunk=100000",
         "pgSphere 1.1.1 / chunk=100000",
         "pgSphere 1.1.2 / chunk=100000", "pgSphere 1.1.5+spoint2 / chunk=100000", "haversine / chunk=100000", "PostGIS 2.1 / chunk=100000"),
       col = c("green", "red", "blue", "magenta", "black", "gray"),
       lty = c(1,1,1,1,1))

# dev.off()
