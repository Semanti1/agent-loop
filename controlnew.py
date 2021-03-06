#!/usr/bin/env python
import roslib; roslib.load_manifest("is_control")
import rospy
import os
#from gringo import Fun,SolveResult,Model
import subprocess
from geometry_msgs.msg import Twist
from is_vision.msg import PioneerPos
from array import *

'''
This script defines all of the pioneer motion primitives. There 
are no encoders on the robot so there is no promise on the distance
the robot will travel. The robot is able to move forward, backward, 
turn right, and turn left. Each turn is as close to 90 degrees as possible. 
Each movement is for 3 seconds
'''
forward = Twist()
forward.linear.x = .3
forward.linear.y = 0
forward.linear.z = 0
forward.angular.x = 0
forward.angular.y = 0
forward.angular.z = 0

back = Twist()
back.linear.x = -0.3
back.linear.y = 0
back.linear.z = 0
back.angular.x = 0
back.angular.y = 0
back.angular.z = 0

right = Twist()
right.linear.x = 0
right.linear.y = 0
right.linear.z = 0
right.angular.x = 0
right.angular.y = 0
right.angular.z = -0.3

left = Twist()
left.linear.x = 0
left.linear.y = 0
left.linear.z = 0
left.angular.x = 0
left.angular.y = 0
left.angular.z = 0.3

stop = Twist()
stop.linear.x = 0
stop.linear.y = 0
stop.linear.z = 0
stop.angular.x = 0
stop.angular.y = 0
stop.angular.z = 0

def turnRight(pub):
    #Do stuff now
    pub.publish(right)
    rospy.sleep(5)
    pub.publish(stop)

def goForward(pub):
    pub.publish(forward)
    rospy.sleep(1.5)
    pub.publish(stop)

def goBack(pub):
    pub.publish(back)
    rospy.sleep(1.5)
    pub.publish(stop)

def turnLeft(pub):
    pub.publish(left)
    rospy.sleep(5)
    pub.publish(stop)

def analyzeMove(data):
    #Print the data when we get it
    print data
def moves(pub,list,t):
   #for x in xrange(0,len(list)-1):
    m=list[t][14]
    print(m)
    if m=='i':
       turnRight(pub)
    elif m=='e':
       turnLeft(pub)
    else:
       goForward(pub) 

def main():
    #Make the node so that we can publish and sleep because it takes a 
    #few seconds to get up and running
    #Advertise I am going to publish
    pub = rospy.Publisher('RosAria/cmd_vel', Twist, queue_size=10)
    rospy.init_node("pyMover", anonymous=True)
    rospy.sleep(5)
       
    #h =open('recorded_history.lp', 'a')
    #####Insert AI here. 
    #try:
    g=""
    i=0
    gob =open('observation.txt', 'r')
    while 1:
        
        if i!=0:
        	
        	goi=open('obs.lp', 'a')
        	inp=gob.readline()
        	goi.write(inp+ "\n")
        	goi.close()
        	
        e="curr_step=%d"%i# invoking diag
        os.system('clingo -c %s domain-descrp.lp goal.lp initial_state.lp diagnostics.lp recorded_history.lp obs.lp | mkatoms 2>/dev/null > outputdiagnostics.txt'%e) 
        go=open('recorded_history.lp', 'ab+')
        do=open('outputdiagnostics.txt','r+')#the diagnosis is:
        
        
        
        while 1:
        	diag=do.readline()
            	if diag=='*** no models found.':
                	print("no diagnosis")
                	break
            	if(diag[0:4]=="expl"):
           			go.write("hpd"+diag[4:(diag.rfind(")"))+1]+"."+"\n")
           			print (diag)
            	else:
           			print("no unexpected obs")
           			break
        go.close()
        do.close()
        mylist=[]        
        g="curr_step=%d"%i
        os.system('clingo -c %s domain-descrp.lp goal.lp initial_state.lp planner.lp obs.lp recorded_history.lp | mkatoms > outputplanner.txt'%g)
        fo = open('outputplanner.txt', 'r+')
        if fo.readline()=='*** no models found.' 
           print("no plans")
           break
        if fo.readline()=='::endmodel':
           print("goal reached")
           break 
        rospy.Subscriber("robot_pos", PioneerPos, analyzeMove)    
        fo.seek(0,0)
        while 1:
           data=fo.readline()
           if data!='':
		 		if data[0:6]=='occurs' and data.find("pioneer")>=0:
		   			mylist.append(data)
           else:
		   		break
        print (mylist)
        fo.close() 
        if i>(len(mylist)-1):
           print("goal reached")
           break
        
        for x in xrange(0,len(mylist)-1):# create new array
		   j=mylist[x].rfind(")")
		   h=mylist[x].rfind(",")
		   index=int(mylist[x][h+1:j])
		   temp=mylist[index]
		   mylist[index]=mylist[x]
		   mylist[x]=temp
        print('The plan is') 
        print (mylist)
        print("action executed now is "+ str(mylist[i]))   
        moves(pub,mylist,i)
        go=open('recorded_history.lp', 'ab+')
        ind=mylist[i].rfind(")")
        out=mylist[i][6:ind+1]+"."
        go.write("hpd"+out+"\n")
        go.close()
        i=i+1            
            
if __name__ == '__main__':
    main()

