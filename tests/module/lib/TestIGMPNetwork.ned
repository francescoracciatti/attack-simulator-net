import inet.networklayer.common.InterfaceTable;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.configurator.ipv4.Ipv4NodeConfigurator;
import inet.networklayer.ipv4.IIgmp;
import inet.networklayer.ipv4.Ipv4RoutingTable;
import inet.common.scenario.ScenarioManager;

module IgmpTesterNic
{
    parameters:
        string interfaceTableModule;
        string routingTableModule;
        *.interfaceTableModule = absPath(interfaceTableModule);
        *.routingTableModule = absPath(routingTableModule);
        @class(InterfaceEntry);
    gates:
        input igmpIn;
        output igmpOut;
    submodules:
        mac: IGMPTester {
            @display("p=70,153");
        }
    connections:
        igmpIn --> mac.igmpIn;
        igmpOut <-- mac.igmpOut;
}

network TestIGMPNetwork
{
    types:
        module TestIGMPNode
        {
            parameters:
                @networkNode;
                *.interfaceTableModule = absPath(".interfaceTable");
                *.routingTableModule = absPath(".routingTable");
            submodules:
                interfaceTable: InterfaceTable {
                    @display("p=57,31");
                }
                routingTable: Ipv4RoutingTable {
                    @display("p=168,31");
                }
                tester: IgmpTesterNic {
                    @display("p=70,153");
                }
                igmp: <default("Igmpv3")> like IIgmp {
                    @display("p=176,153");
                }
                nodeConfigurator: Ipv4NodeConfigurator {
                    @display("p=285,95");
                    networkConfiguratorModule = "";
                    configureRoutingTable = false;
                }
            connections allowunconnected:
                tester.igmpOut --> igmp.ipIn;
                igmp.ipOut --> tester.igmpIn;
        }
    submodules:
        node: TestIGMPNode;
        scenarioManager: ScenarioManager {
            @display("p=139,19");
        }
}
