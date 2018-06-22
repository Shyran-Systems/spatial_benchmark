require(sfsmisc)

setwd('~/compwork/postgres/spherical')

o_pg = scan('out_match_pg', list(t=0, n=0, sr=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_pgi = scan('out_match_pgi', list(t=0, n=0, sr=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_q3c = scan('out_match_q3c', list(t=0, n=0, sr=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_h = scan('out_match_haversine', list(t=0, n=0, sr=0, hbread=0, hbhit=0, ibread=0, ibhit=0))
o_postgis = scan('out_match_postgis', list(t=0, n=0, sr=0, hbread=0, hbhit=0, ibread=0, ibhit=0))

png('fig_match_number_time.png', width=1024, height=768)
plot(o_pg$n, o_pg$t, type="b", pch=2, col="red", log='xy', cex=0.5, xlim=c(1e1,1e7), ylim=c(1e-1,1e8),
     xlab="Number of points matched against 1e7 table", ylab="Query time, ms", axes=FALSE)
lines(o_pgi$n, o_pgi$t, pch=2, col="blue", cex=0.5, type="b")
lines(o_q3c$n, o_q3c$t, pch=2, col="green", cex=0.5, type="b")
lines(o_h$n, o_h$t, pch=2, col="black", cex=0.5, type="b")
lines(o_postgis$n, o_postgis$t, pch=2, col="gray", cex=0.5, type="b")
legend(10, 1e8, list("Q3C", "pgSphere 1.1.5 + spoint2", "pgSphere 1.1.5 + spoint2 + idx", "haversine", "PostGIS 2.1"),
       box.lty=0, col=c("green", "red", "blue", "black", "gray"), lty=1)
box()
eaxis(1)
eaxis(2)
dev.off()
