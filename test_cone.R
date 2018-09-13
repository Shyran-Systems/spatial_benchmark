require(sfsmisc)

setwd('/home/matwey/sci/pgtests_git/run11')

o_pg = scan('out_cone_pg_c_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_q3c = scan('out_cone_q3c_c_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_h = scan('out_cone_haversine_c_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_postgis = scan('out_cone_postgis_c_1000_10', list(t=0, n=0, r=0, hbread=0, hbhit=0, ibread=0, ibhit=0))

# npoints vs time
png('fig_cone_number_time.png', width=1024, height=768)
plot(o_pg$n, o_pg$t, type="p", pch=2, col="red", log='xy', cex=0.5, xlim=c(1,1e6), ylim=c(1e-2,1e6),
     xlab="Numper of points returned", ylab="Query time, ms", axes=FALSE)
points(o_q3c$n, o_q3c$t, pch=2, col="green", cex=0.5)
points(o_h$n, o_h$t, pch=2, col="black", cex=0.5)
points(o_postgis$n, o_postgis$t, pch=2, col="gray", cex=0.5)
legend(1, 1e6, list("Q3C", "pgSphere", "haversine", "PostGIS 2.4"),
       box.lty=0, col=c("green", "red", "black", "gray"), pch=2)
box()
eaxis(1)
eaxis(2)
dev.off()

# radius vs time
png('fig_cone_radius_time.png', width=1024, height=768)
plot(o_pg$r, o_pg$t, pch=2, col="red", cex=0.5, log="xy", ylim=c(1e-2,1e6),
     xlab="Query radius, degrees", ylab="Query time, ms", axes=FALSE)
points(o_q3c$r, o_q3c$t, pch=2, col="green", cex=0.5)
points(o_h$r, o_h$t, pch=2, col="black", cex=0.5)
points(o_postgis$r, o_postgis$t, pch=2, col="gray", cex=0.5)
legend(1e-2, 1e6, list("Q3C", "pgSphere", "haversine", "PostGIS 2.4"),
       box.lty=0, col=c("green", "red", "black", "gray"), pch=2)
box()
eaxis(1)
eaxis(2)
dev.off()

## # npoints vs ibread
png('fig_cone_number_ibread.png', width=1024, height=768)
plot(o_pg$n, o_pg$ibread, pch=2, col="red", cex=0.5, log="xy", ylim=c(1e0,1e6),
    xlab="Number of points returned", ylab="index_blks_read", axes=FALSE)
points(o_q3c$n, o_q3c$ibread, pch=2, col="green", cex=0.5)
points(o_h$n, o_h$ibread, pch=2, col="black", cex=0.5)
points(o_postgis$n, o_postgis$ibread, pch=2, col="gray", cex=0.5)
legend(1e0, 1e6, list("Q3C", "pgSphere", "haversine", "PostGIS 2.4"),
       box.lty=0, col=c("green", "red", "black", "gray"), pch=2)
box()
eaxis(1)
eaxis(2)
dev.off()

png('fig_cone_number_ibreadhit.png', width=1024, height=768)
plot(o_pg$n, o_pg$ibread, pch=2, col="red", cex=0.5, log="xy", ylim=c(1e0,1e6),
    xlab="Number of points returned", ylab="index_blks_read + index_blks_hit", axes=FALSE)
points(o_q3c$n, o_q3c$ibread + o_q3c$ibhit, pch=2, col="green", cex=0.5)
points(o_h$n, o_h$ibread + o_h$ibhit, pch=2, col="black", cex=0.5)
points(o_postgis$n, o_postgis$ibread + o_postgis$ibhit, pch=2, col="gray", cex=0.5)
legend(1e0, 1e6, list("Q3C", "pgSphere", "haversine", "PostGIS 2.4"),
       box.lty=0, col=c("green", "red", "black", "gray"), pch=2)
box()
eaxis(1)
eaxis(2)
dev.off()

## # npoints vs hbread
png('fig_cone_number_hbread.png', width=1024, height=768)
plot(o_pg$n, o_pg$hbread, pch=2, col="red", cex=0.5, log="xy", ylim=c(1e0,1e6),
    xlab="Number of points returned", ylab="heap_blks_read", axes=FALSE)
points(o_q3c$n, o_q3c$hbread, pch=2, col="green", cex=0.5)
points(o_h$n, o_h$hbread, pch=2, col="black", cex=0.5)
points(o_postgis$n, o_postgis$hbread, pch=2, col="gray", cex=0.5)
legend(1e0, 1e6, list("Q3C", "pgSphere", "haversine", "PostGIS 2.4"),
       box.lty=0, col=c("green", "red", "black", "gray"), pch=2)
box()
eaxis(1)
eaxis(2)
dev.off()
