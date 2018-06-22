require(sfsmisc)

setwd('~/compwork/postgres/spherical')

o_pg = scan('out_cone_pg_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_pg_c = scan('out_cone_pg_1000_10_clustered', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_pg2 = scan('out_cone_pg112_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_pg2_c = scan('out_cone_pg112_1000_10_clustered', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_pg5 = scan('out_cone_pg115_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_pg5_c = scan('out_cone_pg115_1000_10_clustered', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_q3c = scan('out_cone_q3c_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_q3c_c = scan('out_cone_q3c_1000_10_clustered', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_h = scan('out_cone_haversine_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_h_c = scan('out_cone_haversine_1000_10_clustered', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_postgis = scan('out_cone_postgis_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_postgis_c = scan('out_cone_postgis_1000_10_clustered', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))

is_png = TRUE

# npoints vs time
if(is_png) png('fig_cone_number_time_clustered_q3c.png', width=1024, height=768)
plot(NULL, log='xy', cex=0.5, xlim=c(1,1e6), ylim=c(1e-2,1e6),
     xlab="Numper of points returned", ylab="Query time, ms", axes=FALSE)
points(o_q3c$n, o_q3c$t, pch=2, col="red", cex=0.5)
points(o_q3c_c$n, o_q3c_c$t, pch=2, col="darkgreen", cex=0.5)
legend(1, 1e6, list("Q3C", "Q3C clustered"), box.lty=0, col=c("red", "darkgreen"), pch=2)
box()
eaxis(1)
eaxis(2)
if(is_png) dev.off()

if(is_png) png('fig_cone_number_time_clustered_pg115.png', width=1024, height=768)
plot(NULL, log='xy', cex=0.5, xlim=c(1,1e6), ylim=c(1e-2,1e6),
     xlab="Numper of points returned", ylab="Query time, ms", axes=FALSE)
points(o_pg5$n, o_pg5$t, pch=2, col="red", cex=0.5)
points(o_pg5_c$n, o_pg5_c$t, pch=2, col="darkgreen", cex=0.5)
legend(1, 1e6, list("pgSphere 1.1.5", "pgSphere 1.1.5 clustered"), box.lty=0, col=c("red", "darkgreen"), pch=2)
box()
eaxis(1)
eaxis(2)
if(is_png) dev.off()

if(is_png) png('fig_cone_number_time_clustered_postgis.png', width=1024, height=768)
plot(NULL, log='xy', cex=0.5, xlim=c(1,1e6), ylim=c(1e-2,1e6),
     xlab="Numper of points returned", ylab="Query time, ms", axes=FALSE)
points(o_postgis$n, o_postgis$t, pch=2, col="red", cex=0.5)
points(o_postgis_c$n, o_postgis_c$t, pch=2, col="darkgreen", cex=0.5)
legend(1, 1e6, list("PostGIS 2.1", "PostGIS 2.1 clustered"), box.lty=0, col=c("red", "darkgreen"), pch=2)
box()
eaxis(1)
eaxis(2)
if(is_png) dev.off()

if(is_png) png('fig_cone_number_time_clustered_haversine.png', width=1024, height=768)
plot(NULL, log='xy', cex=0.5, xlim=c(1,1e6), ylim=c(1e-2,1e6),
     xlab="Numper of points returned", ylab="Query time, ms", axes=FALSE)
points(o_h$n, o_h$t, pch=2, col="red", cex=0.5)
points(o_h_c$n, o_h_c$t, pch=2, col="darkgreen", cex=0.5)
legend(1, 1e6, list("haversine", "haversine clustered"), box.lty=0, col=c("red", "darkgreen"), pch=2)
box()
eaxis(1)
eaxis(2)
if(is_png) dev.off()


## if(is_png) png('fig_cone_number_time_clustered_postgis.png', width=1024, height=768)
## plot(NULL, log='xy', cex=0.5, xlim=c(1,1e6), ylim=c(1e-2,1e6),
##      xlab="Numper of points returned", ylab="Query time, ms", axes=FALSE)
## points(o_postgis$n, o_postgis$hbhit, pch=2, col="red", cex=0.5)
## points(o_postgis_c$n, o_postgis_c$hbhit, pch=2, col="darkgreen", cex=0.5)
## legend(1, 1e6, list("PostGIS 2.1", "PostGIS 2.1 clustered"), box.lty=0, col=c("red", "darkgreen"), pch=2)
## box()
## eaxis(1)
## eaxis(2)
## if(is_png) dev.off()
