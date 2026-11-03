import jenkins.model.*
import hudson.security.*

println("--> Starting Lab 20 RBAC Configuration")

def instance = Jenkins.getInstance()

// 1. Create Users: user1 and user2
def realm = instance.getSecurityRealm()
if (realm instanceof HudsonPrivateSecurityRealm) {
    def users = [
        [username: 'user1', password: 'user1password', fullname: 'User One'],
        [username: 'user2', password: 'user2password', fullname: 'User Two']
    ]
    users.each { u ->
        try {
            realm.createAccount(u.username, u.password)
            def createdUser = realm.getUser(u.username)
            if (createdUser != null) {
                createdUser.setFullName(u.fullname)
                createdUser.save()
            }
            println("Created user: ${u.username}")
        } catch (Exception e) {
            println("User ${u.username}: " + e.message)
        }
    }
}

// 2. Load Role-Based Strategy classes
def cl = instance.pluginManager.uberClassLoader
def RoleClass = cl.loadClass("com.michelin.cio.hudson.plugins.rolestrategy.Role")
def RoleMapClass = cl.loadClass("com.michelin.cio.hudson.plugins.rolestrategy.RoleMap")
def StrategyClass = cl.loadClass("com.michelin.cio.hudson.plugins.rolestrategy.RoleBasedAuthorizationStrategy")

// Permissions IDs for Admin
Set<String> adminPerms = new HashSet<>()
adminPerms.add("hudson.model.Hudson.Administer")

// Permissions IDs for Read-Only
Set<String> readPerms = new HashSet<>()
readPerms.add("hudson.model.Hudson.Read")
readPerms.add("hudson.model.Item.Read")
readPerms.add("hudson.model.View.Read")

// Use public constructor: Role(String name, String pattern, Set<String> permissionIDs, String description)
def roleCtor = RoleClass.getConstructor(String, String, Set, String)
def adminRole = roleCtor.newInstance("admin", ".*", adminPerms, "Administrator Role")
def readOnlyRole = roleCtor.newInstance("read-only", ".*", readPerms, "Read-Only Role")

// Configure RoleMap
def globalRoleMap = RoleMapClass.newInstance()
globalRoleMap.addRole(adminRole)
globalRoleMap.addRole(readOnlyRole)

globalRoleMap.assignRole(adminRole, "user1")
globalRoleMap.assignRole(adminRole, "moha_96")
globalRoleMap.assignRole(readOnlyRole, "user2")

Map grantedRoles = new HashMap()
grantedRoles.put("globalRoles", globalRoleMap)
grantedRoles.put("projectRoles", RoleMapClass.newInstance())
grantedRoles.put("slaveRoles", RoleMapClass.newInstance())

def strategy = StrategyClass.getConstructor(Map).newInstance(grantedRoles)
instance.setAuthorizationStrategy(strategy)
instance.save()

println("--> SUCCESS: Lab 20 RBAC Configuration Completed Successfully!")
